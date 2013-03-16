module AwsBackup
  class CloudBackupManager < Thor
    def initialize(*args)
      super
      @console = ConsolePrinter.instance
      @credentials = CredentialManager.instance
    end

    desc "list", "List the provisioned backup accounts, and indicate whether they are correctly setup in IAM"
    def list
      execute_command("Accounts") do
        BackupAccount.list.each do |account|
          @console.print account.name + ': ', :newline => false
          user_status = (account.check_user) ? 'V'.color(:green) : 'X'.color(:red)
          @console.print user_status
        end
      end
    end

    desc 'rotate', 'Rotate keys for a backup user'
    def rotate(backup_name)
      execute_command("Access Keys") do
        account = BackupAccount.find(backup_name)
        access_credentials = account.rotate
        @console.print "Created new credentials for #{backup_name}:"
      
        print_credentials(access_credentials.credentials)
      end
    end

    desc 'provision', 'Create a new backup account'
    def provision(backup_name)
      execute_command("New Account") do
        @console.print "Creating new account..."
        account = BackupAccount.new(backup_name)
        access_credentials = account.provision
        @console.print "Success! Your new account was created successfuly. These are the credentials:"
        @console.print "Bucket: #{account.full_name}"
        print_credentials(access_credentials.credentials)
      end
    end

    desc 'console', 'Interactive backup console'
    def console
      ARGV.clear
      IRB.start
    end

  private
    def print_credentials(credentials)
      @console.print "Access: #{credentials[:access_key_id]}"
      @console.print "Secret: #{credentials[:secret_access_key]}"
      @console.print "These keys will not be shown again, keep them safe!"
    end

    def execute_command(title)
      @console.print_header(title)
      begin
        yield
      rescue AWS::S3::Errors::AccessDenied
        @console.print "AWS cloud access denied. Pease check keys and permissions", :color => :red
      rescue 
        @console.print $!.message, :color => :red
        $!.backtrace.each{|l| @console.print l}
      end
      @console.line
    end
  end
end