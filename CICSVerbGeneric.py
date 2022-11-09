class CICSVerbGeneric:
    def __init__(self):
        pass

    def process(self, exec_array, abend, outfile):
        print("Unknown Verb: " + "|".join(exec_array))

    def get_result(self):
        return ""

    def set_abend_statement(self):
        return False