from PreCompileConstants import *

class CICSVerbLink:
    def __init__(self):
        pass

    def process(self, exec_array, abend, outfile):
        count = 0
        for verb in exec_array:
            if verb.startswith(END_CICS_STATEMENT):
                if verb.endswith(PERIOD):
                    append_file(outfile, CBL_PREFIX + abend + PERIOD + NEWLINE)
            elif verb == "PROGRAM":
                if len(exec_array) >= count + 4:
                    if exec_array[count + 4] == "LENGTH":
                        lenvar = cleanup_arg(exec_array[count + 5]) + SPACE
                        count2 = 5
                        if ")" not in exec_array[count + count2]:
                            notfound = True
                            while notfound:
                                count2 = count2 + 1
                                lenvar = lenvar + cleanup_arg(exec_array[count + count2]) + SPACE
                                if ")" in exec_array[count + count2]:
                                    notfound = False
                        append_file(outfile, CBL_PREFIX + "COMPUTE COMCALEN = " + lenvar + NEWLINE)
                if exec_array[count - 1] == "LINK":
                    append_file(outfile, CBL_PREFIX + "MOVE 'D ' TO COMFN" + NEWLINE)
                    append_file(outfile, CBL_PREFIX + "MOVE 'LINK' TO COMTRNID" + NEWLINE)
                if exec_array[count - 1] == "XCTL":
                    append_file(outfile, CBL_PREFIX + "MOVE 'DS' TO COMFN" + NEWLINE)
                    append_file(outfile, CBL_PREFIX + "MOVE 'XCTL' TO COMTRNID" + NEWLINE)
                if exec_array[count + 2] == "COMMAREA":
                    append_file(outfile, CBL_PREFIX + "MOVE " + cleanup_arg(exec_array[count + 3]) + " TO COMDATAREC" + NEWLINE)
                append_file(outfile, CBL_PREFIX + "MOVE " + cleanup_arg(exec_array[count + 1]) + ' TO COMRSRCE' + NEWLINE)
                append_file(outfile, CBL_PREFIX + "CALL 'CICSCNTL' USING DFHCOMLK" + NEWLINE)

            count = count + 1

    def get_result(self):
        return ""

    def set_abend_statement(self):
        return False