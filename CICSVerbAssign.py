from PreCompileConstants import *

class CICSVerbAssign:
    def __init__(self):
        pass

    def process(self, exec_array, abend, outfile):
        count = 0
        for verb in exec_array:
            if verb.startswith(END_CICS_STATEMENT):
                if verb.endswith(PERIOD):
                    append_file(outfile, CBL_PREFIX + PERIOD + NEWLINE)
            elif verb == "INVOKINGPROG":
                append_file(outfile, CBL_PREFIX + "MOVE EIBRSRCE TO " + cleanup_arg(exec_array[count + 1]) + NEWLINE)
            elif verb == "STARTCODE":
                append_file(outfile, CBL_PREFIX + "MOVE EIBFN TO " + cleanup_arg(exec_array[count + 1]) + NEWLINE)

            count = count + 1

    def get_result(self):
        return ""

    def set_abend_statement(self):
        return False

    