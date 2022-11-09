from CICSVerbAssign import *
from CICSVerbHandle import *
from CICSVerbGeneric import *
from CICSVerbLink import *

def CreateVerb(verb):
    val = CICSVerbGeneric()
    if verb == "ASSIGN":
        val = CICSVerbAssign()
    elif verb == "HANDLE":
        val = CICSVerbHandle()
    elif verb == "LINK" or verb == "XCTL":
        val = CICSVerbLink()
    
    return val