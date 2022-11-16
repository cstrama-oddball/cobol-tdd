from PreCompileConstants import *

class fileInfo:
    record_name = "nothing"
    file_name = EMPTY_STRING
    record_key = "nothing"
    file_status = EMPTY_STRING
    def __init__(self, filename):
        global file_name
        file_name = filename

filename = EMPTY_STRING
rec_key = EMPTY_STRING
record = EMPTY_STRING

def process(line, fileInfos):
    global filename
    tmp = line
    tmp_array = tmp.split(SPACE)
    index = 0
    if "ASSIGN" in tmp_array:
        i = tmp_array.index("ASSIGN")
        index = i
        for x in range(i + 1, len(tmp_array)):
            index = index + 1
            if tmp_array[index]  != EMPTY_STRING:
                tmp = tmp_array[index]
                tmp_array[index] = "'" + tmp_array[index].replace(NEWLINE, EMPTY_STRING) + ".txt'" + NEWLINE
                if tmp.endswith(PERIOD):
                    tmp_array[index] = tmp_array[index] + PERIOD

        i = tmp_array.index("SELECT")
        index = i
        for x in range(i + 1, len(tmp_array)):
            index = index + 1
            if tmp_array[index] != EMPTY_STRING:
                filename = tmp_array[index]
                addFile(filename, fileInfos)
                break

    elif "ORGANIZATION" in tmp_array:
        i = tmp_array.index("ORGANIZATION")
        index = i
        for x in range(i + 1, len(tmp_array)):
            index = index + 1
            if tmp_array[index]  != EMPTY_STRING:
                tmp = tmp_array[index]
                tmp_array[index] = "SEQUENTIAL"
                if PERIOD in tmp:
                    tmp_array[index] = tmp_array[index] + PERIOD
                if tmp.endswith(NEWLINE):
                    tmp_array[index] = tmp_array[index] + NEWLINE
                
    elif "ACCESS" in tmp_array:
        i = tmp_array.index("ACCESS")
        index = i
        for x in range(i + 1, len(tmp_array)):
            index = index + 1
            if tmp_array[index]  != EMPTY_STRING:
                tmp = tmp_array[index]
                tmp_array[index] = "SEQUENTIAL"
                if PERIOD in tmp:
                    tmp_array[index] = tmp_array[index] + PERIOD
                if tmp.endswith(NEWLINE):
                    tmp_array[index] = tmp_array[index] + NEWLINE

    elif "STATUS" in tmp_array:
        assignFileStatus(filename, tmp_array[len(tmp_array) - 1].replace(NEWLINE, EMPTY_STRING), fileInfos)

    elif "RECORD" in tmp_array:
        tmp_array = tmp_array #[NEWLINE]
        i = -2
        iskey = False
        if "KEY" in tmp_array:
            i = tmp_array.index("KEY")
            tmp_array[6] = "*"
            iskey = True
        else:
            i = tmp_array.index("RECORD")

        index = i
        r = EMPTY_STRING
        for x in range(i + 1, len(tmp_array)):
            index = index + 1
            if tmp_array[index] != EMPTY_STRING:
                if iskey:
                    rec_key = tmp_array[index]
                    r = rec_key
                    assignFileRecordKey(filename, r, fileInfos)
                    break
                else:
                    record = tmp_array[index]
                    r = record
                    assignFileRecord(filename, r, fileInfos)
                    break

    val = ""
    for v in tmp_array:
        if v.endswith(NEWLINE) == False:
            val = val + v + SPACE
        else:
            val = val + v
        
    return val

def processFileVerb(line, fileInfos, outfilename):
    verb_array = line.split(SPACE)
    fname = EMPTY_STRING
    t = EMPTY_STRING
    for x in range (1, len(verb_array)):
        if verb_array[x] != EMPTY_STRING:
            fname = verb_array[x]

    if line.startswith("READ"):
        for x in fileInfos:
            if fname == x.file_name:
                t = build_verb("READ",fname,x,line, outfilename)
                t = t + CBL_PREFIX + "MOVE ZERO TO " + x.file_status + NEWLINE
                break
           
    elif line.startswith("REWRITE"):
        for x in fileInfos:
            if fname == x.record_name:
                t = build_verb("REWRITE",fname,x,line, outfilename)
                t = t + CBL_PREFIX + "MOVE ZERO TO " + x.file_status + NEWLINE
                break

    elif line.startswith("OPEN"):
        for x in fileInfos:
            if fname == x.file_name:
                t = CBL_PREFIX + "MOVE ZERO TO " + x.file_status + NEWLINE
                #t = t + CBL_PREFIX + "OPEN INPUT " + x.file_name
                if PERIOD in line:
                    t = t + PERIOD
                t = t + NEWLINE
                break
    return t

def build_verb(verb,fname,x,line,outfilename):
    t = EMPTY_STRING
    t = t + CBL_PREFIX + "MOVE '" + x.file_name + "' TO FS-FILE-NAME" + NEWLINE
    t = t + CBL_PREFIX + "MOVE " + str(len(x.file_name)) + " TO FS-FILE-NAME-LENGTH" + NEWLINE
    t = t + CBL_PREFIX + "MOVE '" + verb + "' TO FS-VERB" + NEWLINE
    t = t + CBL_PREFIX + "COMPUTE FS-FILE-REC-LENGTH = LENGTH OF " + x.record_name + NEWLINE
    if x.record_key != EMPTY_STRING:
        t = t + CBL_PREFIX + "COMPUTE FS-FILE-KEY-LENGTH = LENGTH OF " + x.record_key + NEWLINE
        t = t + CBL_PREFIX + "MOVE " + x.record_key + " TO FS-FILE-KEY" + NEWLINE
    t = t + CBL_PREFIX + "MOVE " + x.record_name + " TO FS-FILE-RECORD" + NEWLINE

    t = t + CBL_PREFIX + "CALL 'CBLFILE-" + outfilename + "' USING FS-INFO-DATA" + NEWLINE 
    t = t + CBL_PREFIX + "                                 , FS-FILE-KEY-INFO-DATA" + NEWLINE
    t = t + CBL_PREFIX + "                                  , " + x.record_name + NEWLINE

    if PERIOD in line:
        t = t + PERIOD
    t = t + NEWLINE

    return t
 
def allocateFile(line, fileInfos):
    file_array = line.split(SPACE)
    count = 0
    filename = EMPTY_STRING
    for x in file_array:
        if (count > 0) and x != EMPTY_STRING:
            filename = x
            break
        count = count + 1

    if (filename != EMPTY_STRING):
        fileInfos = addFile(filename, fileInfos)

    return fileInfos, filename

def addFile(filename, fileInfos):
    found = False
    for x in fileInfos:
        if x.file_name == filename:
            found = True
            break
    
    if found == False:
        fileInfos.append(fileInfo(filename))
        fileInfos[len(fileInfos) - 1].file_name = filename

    return fileInfos

def assignFileRecord(filename, line, fileInfos):
    recname = EMPTY_STRING
    file_array = line.split(SPACE)
    count = 1
    if (len(file_array) < 2):
        count = 0
    for x in range(count, len(file_array)):
        if file_array[x] != EMPTY_STRING:
            recname = file_array[x]
            break

    found = False
    fi = None
    for x in fileInfos:
        if x.file_name == filename:
            found = True
            fi = x
            break

    if found:
        fi.record_name = recname.replace(PERIOD, EMPTY_STRING)

    return fileInfos

def assignFileRecordKey(filename, line, fileInfos):
    recname = line.replace(NEWLINE, EMPTY_STRING)
    found = False
    fi = None
    for x in fileInfos:
        if x.file_name == filename:
            found = True
            fi = x
            break

    if found:
        fi.record_key = recname.replace(PERIOD, EMPTY_STRING)

    return fileInfos

def assignFileStatus(filename, filestatus, fileInfos):
    found = False
    fi = None
    for x in fileInfos:
        if x.file_name == filename:
            found = True
            fi = x
            break

    if found:
        fi.file_status = filestatus

def getFileInfo(filename,fileInfos):
    fi = None
    for x in fileInfos:
        if x.file_name == filename:
            fi = x
            break

    return fi

def findRecKey(filename,fileInfos):
    fi = None
    for x in fileInfos:
        if x.file_name == filename:
            fi = x
            break

    if fi == None:
        return EMPTY_STRING

    return fi.record_key

def findRecord(filename,fileInfos):
    fi = None
    for x in fileInfos:
        if x.file_name == filename:
            fi = x
            break

    if fi == None:
        return EMPTY_STRING

    return fi.record_name

def findFileNameByRecord(recname,fileInfos):
    fi = None
    for x in fileInfos:
        if x.record_name == recname:
            fi = x
            break

    if fi == None:
        return EMPTY_STRING

    return fi.file_name