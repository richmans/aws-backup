# AwsBackup
If you want to use amazon S3 for your automated server or website backups, this gem can help you provisioning accounts on amazon S3 and IAM. It takes care of creating the bucket, users, policies and access keys.

## Installation

Add this line to your application's Gemfile:

    gem 'aws_backup'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aws_backup

## Usage

    Tasks:
      aws-backup console      # Interactive backup console
      aws-backup help [TASK]  # Describe available tasks or one specific task
      aws-backup list         # List the provisioned backup accounts, and indicate whether they are correctly setup in IAM
      aws-backup provision    # Create a new backup account
      aws-backup rotate       # Rotate keys for a backup user



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
