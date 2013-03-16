module AwsBackup
  class CredentialManager
    include Singleton
    def initialize
      @credential_file = File.expand_path('~/.aws_credentials')
      @console = ConsolePrinter.instance
    end

    def reset
      File.delete(@credential_file)
      @parameters = nil
    end

    def parameters
      @parameters = read_from_file if @parameters.nil?
      @parameters = ask_parameters if @parameters.nil?
      @parameters
    end

    def ask_parameters
      new_parameters = {}
      new_parameters[:access] = @console.ask("Your AWS Access key")
      new_parameters[:secret] = @console.ask("Your AWS Secret key")
      save_parameters(new_parameters)
      new_parameters
    end

    def save_parameters(new_parameters)
      begin
        file = File.open(@credential_file, 'w')
        parameters = {}
        file.puts new_parameters[:access]
        file.puts new_parameters[:secret]
        file.close
        File.chmod(0700, @credential_file)
      rescue
        @console.print "Credential file could not be written: #{$!.message}", :color => :red
      end
    end

    def read_from_file
      begin
        file = File.open(@credential_file, 'r')
        read_parameters = {}
        read_parameters[:access] = file.gets.strip
        read_parameters[:secret] = file.gets.strip
        
        file.close
        return read_parameters
      rescue
        @console.print "Credential file was not found"
        return nil
      end
      
    end

    def access_key
      parameters[:access]
    end

    def secret_key
      parameters[:secret]
    end

  end
end