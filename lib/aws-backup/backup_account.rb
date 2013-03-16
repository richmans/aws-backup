module AwsBackup
  class BackupAccount
    attr_reader :name
    def initialize(bucket)
      if bucket.is_a? String
        @name = bucket
      else
        name_match = bucket.name.match(/^backup-(.*)/)
        raise "Not a valid backup bucket" unless name_match
        @name = name_match[1]
      end
    end
   
    def full_name
      "backup-#{name}"
    end

    def check_user
      iam.users["backup-#{name}"].exists?
    end

    def iam_policy
      policy = AWS::IAM::Policy.new do |policy|
        policy.allow(:actions => ['s3:ListBucket'],
                     :resources => "arn:aws:s3:::#{full_name}",
                     :principals => :any
        )

        policy.allow(:actions => ['s3:DeleteObject', 's3:PutObject', 's3:PutObjectAcl'],
                      :resources =>  "arn:aws:s3:::#{full_name}/*",
                      :principals => :any
        )
      end
    end

    def provision
      provision_bucket
      provision_user
      rotate
    end

    def provision_bucket
      bucket = s3.buckets[full_name]
      raise "Bucket already exists" if bucket.exists?
      s3.buckets.create(full_name, :location_constraint => 'eu-west-1')
    end

    def provision_user
      raise "User already exists" if check_user
      user = iam.users.create(full_name)
      group = iam.groups['backup']
      user.groups.add group
      user.policies["#{full_name}-policy"] = iam_policy
    end

    def rotate
      user = iam.users[full_name]
      user.access_keys.clear
      user.access_keys.create
    end

    def self.iam
      return @iam unless @iam.nil?
      @iam = AWS::IAM.new(
        :access_key_id => CredentialManager.instance.access_key,
        :secret_access_key => CredentialManager.instance.secret_key)
    end

    def iam
      BackupAccount.iam
    end

    def self.s3
      return @s3 unless @s3.nil?
      @s3 = AWS::S3.new(
        :access_key_id => CredentialManager.instance.access_key,
        :secret_access_key => CredentialManager.instance.secret_key )
    end

    def s3
      BackupAccount.s3
    end

    def self.list
      s3.buckets.select{|b| b.name =~ /^backup-/}.collect{|b| BackupAccount.new(b)}
    end

    def self.find(name)
      bucket = s3.buckets["backup-#{name}"]
      raise "Backup account not found" unless bucket.exists?
      BackupAccount.new(bucket)
    end
  end
end