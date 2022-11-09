from PreCompileConstants import *
cics_abend_statement = ""

class CICSVerbHandle:
    def __init__(self):
        pass

    def process(self, exec_array, abend, outfile):
        global cics_abend_statement
        if exec_array[3] == "ABEND":
            cics_abend_statement = "IF COMRESP NOT = 0\n" + CBL_PREFIX + "  PERFORM " + cleanup_arg(exec_array[5] + "\n" + CBL_PREFIX + "END-IF")

    def get_result(self):
        global cics_abend_statement
        return cics_abend_statement

    def set_abend_statement(self):
        return True