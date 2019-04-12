# Alyssa has been assigned a task of modifying a class that was initially created to keep track of secret information. 
# The new requirement calls for adding logging, when clients of the class attempt to access the secret data. Here is the class in its current form:
# She needs to modify it so that any access to data must result in a log entry being generated. 
# That is, any call to the class which will result in data being returned must first call a logging class. 

class SecretFile
  attr_reader :logs

  def initialize(secret_data, logger)
    @data = secret_data
    @logger = logger
    @logs = []
  end

  def data
    @logs << @logger.create_log_entry
    @data
  end
end

class SecurityLogger
  def create_log_entry
    Time.new
  end
end

secret_file = SecretFile.new("I am a spy.", SecurityLogger.new)
p secret_file.data
p secret_file.data
p secret_file.logs
