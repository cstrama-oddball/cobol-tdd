import os

from os.path import exists

INCLUDE_STRING = "*++INCLUDE "
COPY_STRING = "COPY "
COMMENT_STRING = "*"
OTHER_COMMENT_STRING = "/"
NEWLINE = "\n"
APPEND_FLAG = "a"
EMPTY_STRING = ""
PERIOD = "."
CICS_DELIMITER = "|"
SPACE = " "
CBL_PREFIX = "           "
CICS_STATEMENT = "EXEC CICS"
END_CICS_STATEMENT = "END-EXEC"
LINKAGE_SECTION = "LINKAGE SECTION."
FILE_STATEMENT = "FILE-CONTROL"
FILE_SECTION = "FILE-SECTION."
WORKING_STORAGE_SECTION = "WORKING-STORAGE SECTION."
DATA_DIVISION = "DATA DIVISION."
PROCEDURE_DIVISION = "PROCEDURE DIVISION"
CICSLINK_COPYBOOK = "CICSLINK"
CICSWORK_COPYBOOK = "CICSWORK"
CICSDHFC_COPYBOOK = "CICSDHFC"
USING_STATEMENT = " USING "
DFHEIBLK = "DFHEIBLK"
COPYBOOK_EXT = ".cpy"
FILE_CALL_COPYBOOK = "FILE_CALL_COPYBOOK"
IGNORE_FILE = "CBLFILE.cbl"
COPYBOOK_FOLDER = "copybooks/"
CBL_COMMENT = "      *"

def cleanup_arg(a):
    return a.replace("(", EMPTY_STRING).replace(")", EMPTY_STRING).replace(CICS_DELIMITER, SPACE)

def append_file(file,data):
        _write_file_data(file,data,APPEND_FLAG)

def _write_file_data(file,data,method):
    f = open(file,method)
    f.write(data)
    f.close()

def delete_file(file):
    if exists(file):
        os.remove(file)