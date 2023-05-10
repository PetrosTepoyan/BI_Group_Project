

## https://docs.python.org/3/library/logging.html

class LoggingService:

    def __init__(self, log_dir: str = "log"):
        self.log_dir = log_dir
        print("Saving logs to", log_dir)

    def __write_to_log(self, message):
        pass
    
    def __print_log(self, message):
        pass

    def log_create_table(self, ...):
        pass
        switch through self.verbose_level

        self.__print_log(message)
        self.__write_to_log(message)
        
        # print in consolue
        # write a line to log.txt

    def log_drop_table...