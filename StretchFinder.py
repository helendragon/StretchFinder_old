#!/usr/bin/env python
from tkinter import filedialog
from tkinter import *
import tkinter as tk
import tkinter as ttk
import os
import urllib.parse
import urllib.request
from os.path import join as pjoin
from tkinter import messagebox
from tkinter.ttk import *


from tkinter import *
import tkinter as tk
from tkinter import ttk

from Utilities.Functions import *

import webbrowser
import platform



class CreateToolTip(object):
    """
    create a tooltip for a given widget
    """
    def __init__(self, widget, text='widget info'):
        self.waittime = 500     #miliseconds
        self.wraplength = 1500   #pixels
        self.widget = widget
        self.text = text
        self.widget.bind("<Enter>", self.enter)
        self.widget.bind("<Leave>", self.leave)
        self.widget.bind("<ButtonPress>", self.leave)
        self.id = None
        self.tw = None

    def enter(self, event=None):
        self.schedule()

    def leave(self, event=None):
        self.unschedule()
        self.hidetip()

    def schedule(self):
        self.unschedule()
        self.id = self.widget.after(self.waittime, self.showtip)

    def unschedule(self):
        id = self.id
        self.id = None
        if id:
            self.widget.after_cancel(id)

    def showtip(self, event=None):
        x = y = 0
        x, y, cx, cy = self.widget.bbox("insert")
        x += self.widget.winfo_rootx() + 25
        y += self.widget.winfo_rooty() + 20
        # creates a toplevel window
        self.tw = tk.Toplevel(self.widget)
        # Leaves only the label and removes the app window
        self.tw.wm_overrideredirect(True)
        self.tw.wm_geometry("+%d+%d" % (x, y))
        label = tk.Label(self.tw, text=self.text, justify='left',
                       background="#ffffff", relief='solid', borderwidth=1,
                       wraplength = self.wraplength)
        label.pack(ipadx=1)

    def hidetip(self):
        tw = self.tw
        self.tw= None
        if tw:
            tw.destroy()



LARGE_FONT= ("Verdana", 12)
NORM_FONT= ("Verdana", 10)
SMALL_FONT= ("Verdana", 8)
value=0
selected=None
global selccds
global selid 
selid=False
selccds=False

if platform.system()=="Linux":
    directori=os.getcwd()
    directori=directori.replace("\\", "/")
else:
    directori=os.getcwd()
    directori=directori.replace("\\", "/")

print (directori)
def popupmsg(msg):
    quote=msg
    messagebox.showinfo('FASTA file Creator', quote)

inputRW=""
outRW="" 

#read Codon txt
codons= open(directori+"/Utilities/conversionCodonstoR.txt", "r")
PtoR={} #el que tenim a python al ordre de R - per passar a codi
RtoP={} #de R a python - per marcar
for line in codons:
    line=line.strip()
    cod=line.split(";")
    PtoR[int(cod[0])]=int(cod[1])
    RtoP[int(cod[1])]=int(cod[0])
codons.close()

codons=open(directori+"/Utilities/allcodsAA.txt")
codonList=[]
for line in codons:
    line=line.strip()
    cod=line.split(" - ")
    codonList.append(cod[1])
codons.close()

def runp(): 
    
    def select_file(label):
        global inputRW
        filename = filedialog.askopenfilename(title="Select Fasta file")
        label.configure(text=filename)
        inputRW=filename

    def select_dir(label):
        global outRW
        filename = filedialog.askdirectory(title="Select Output Directory")
        label.configure(text=filename)
        outRW=filename
        
    def create_cbutsd(label):
        root = Toplevel()
        root.title("d Codons")
        name=directori+"/Utilities/allCodsAA.txt"
        f9000=open(name,'r')
        listaa1=f9000.readlines()
        cbuts_textd = listaa1
        cbutsd = []
        i=0
        j=0
        varis=[]
        for index, item in enumerate(cbuts_textd):
            var=IntVar()
            cbutsd.append(Checkbutton(root, text = item, variable=var))
            cbutsd[index].grid(column=i,row=j, padx=10)
            j=j+1
            if j==4:
                i=i+1
                j=0
            varis.append(var)
        def deselect_all():
            for i in cbutsd:
                i.deselect()
        def select_dTAPS():
            deselect_all()
            listdTAPS=[37,38,40,21,22,24,5,6,8,53,54,56] #R format
            for i in listdTAPS:
                e=RtoP[i]
                e=e-1
                cbutsd[e].select()     
        def select_dLIVR_dTAPS():       
            deselect_all()
            listdTAPSLIVR=[37,38,40,21,22,24,5,6,8,53,54,56,29,30,32,45,46,48,25,26,28,13,14,16]
            for i in listdTAPSLIVR:
                e=RtoP[i]
                e=e-1
                cbutsd[e].select()

        def select_all():
            for i in cbutsd:
                i.select()

        def okd():
            yesno=[]
            for i in varis:
                yesno.append(i.get())
            n=1
            rlist=[]
            for i in yesno:
                if i:
                    rlist.append(n)
                n=1+n
            print(rlist)
            rlist_R=[]
            for i in rlist:
                r=PtoR[i]
                rlist_R.append(r)
            awrite="dtCod=c("
            for i in rlist_R:
                awrite=awrite+str(i)+","
            awrite=awrite[:-1]
            awrite=awrite+")"
            label.configure(text=awrite)
            root.destroy()

        nnba4=Button(root ,  text="I34 (TAPS)", command=select_dTAPS)
        nnba4.grid(column=2,row=6)
        nnba6=Button(root ,  text="I34", command=select_dLIVR_dTAPS)
        nnba6.grid(column=1,row=6)
        nnba7=Button(root,  text="Unselect all", command=deselect_all)
        nnba7.grid(column=4,row=6)
        nnba9=Button(root,  text="Select all", command=select_all)
        nnba9.grid(column=3,row=6)
        nnba8=Button(root,  text="OK", command=okd)
        nnba8.grid(column=5,row=6)     
        mainloop()

    def create_cbutsa(label):
        root = Toplevel()
        root.title("a Codons")
        name=directori+"/Utilities/allCodsAA.txt"
        f900=open(name,'r')
        listaa=f900.readlines()
        cbuts_text = listaa
        cbuts = []
        i=0
        j=0
        varis=[]
        for index, item in enumerate(cbuts_text):
            var=IntVar()
            cbuts.append(Checkbutton(root, text = item, variable=var))
            cbuts[index].grid(column=i,row=j, padx=10)
            j=j+1
            if j==4:
                i=i+1
                j=0
            varis.append(var)
        def deselect_all():
                for i in cbuts:
                    i.deselect()

        def select_aTAPS():
                deselect_all()
                listaTAPS=[37,38,39,40,21,22,23,24,5,6,7,8,53,54,55,56]#format R
                for i in listaTAPS:
                    e=RtoP[i]
                    e=e-1
                    cbuts[e].select()  
            
        def select_aLIVR_aTAPS():
                deselect_all()
                listaTAPSLIVR=[37,38,39,40,21,22,23,24,5,6,7,8,53,54,55,56,29,30,31,32,61,63,13,14,16,45,46,47,48,25,26,27,28,9,11] #format R
                for i in listaTAPSLIVR:
                    e=RtoP[i]
                    e=e-1
                    cbuts[e].select()
        
        def select_all():
            for i in cbuts:
                i.select()
            
        def oka():
            yesno=[]
            for i in varis:
                yesno.append(i.get())
            n=1
            rlist=[]
            for i in yesno:
                if i:
                    rlist.append(n)
                n=1+n
            print(rlist) #format P
            rlist_R=[]
            for i in rlist:
                r=PtoR[i]
                rlist_R.append(r)
            print(rlist_R)
            awrite="atCod=c("
            for i in rlist_R:
                awrite=awrite+str(i)+","
            awrite=awrite[:-1]
            awrite=awrite+")"
            label.configure(text=awrite)
            root.destroy()

        nba4=Button(root ,  text="I34 (TAPS)", command=select_aTAPS)
        nba4.grid(column=2,row=6)
        nba6=Button(root ,  text="I34", command=select_aLIVR_aTAPS)
        nba6.grid(column=1,row=6)
        nba7=Button(root,  text="Unselect all", command=deselect_all)  
        nba7.grid(column=4,row=6)
        nba9=Button(root,  text="Select all", command=select_all)  
        nba9.grid(column=3,row=6) 
        nba8=Button(root,  text="OK", command=oka)
        nba8.grid(column=5,row=6) 
        mainloop()      
    
    def test(): 
        global inputRW

        name=outRW+"/run.R"
        run=open(name, "w")
        
        run.write("rm(list=ls())"+"\n")
        run.write("options(stringsAsFactors=FALSE)"+"\n")
        if platform.system() !="Windows": #mirem quin OS es
            run.write("setFunc <- '"+ directori+"/Utilities/scripts/functions/strLibrary.R'\n")
            core=", core=8"
        else: 
            run.write("setFunc <- '"+ directori+"/Utilities/scripts/functions/strLibrary.R'\n")
            core=", core=1"
        run.write("setwd('"+ directori+"/Utilities/scripts/functions')\n")
        run.write("source(setFunc)"+"\n")
        run.write("organ<-'humanCCDS'"+"\n")
        thredef=spin.get()
        wsdef=spin1.get()

        if outRW=="":
            messagebox.showerror("Error", "Please select an output directory!")
            return None
        
        if inputRW=="":
            messagebox.showerror("Error", "Please select a Fasta File!")
            return None
        
        if wsdef == "0":
            messagebox.showerror("Error", "Window Size cannot be 0")
            return None
        
        if thredef == "0":
            messagebox.showerror("Error", "Threshold cannot be 0")
            return None
        
        if aw['text'] == "atCod=0":
            messagebox.showerror("Error", "Please Select A Codons")
            return None

        if dw['text'] == "dtCod=0":
            messagebox.showerror("Error", "Please Select D Codons")
            return None

        command="rw(\""+outRW+"\", "+wsdef+", "+thredef+", robust=T, organism=organ, "+ aw['text'] +"," + dw['text'] +", Ethr=" + str(Ethr.get())+core
        
        command=command+", fasta=T, sourceFasta=\""+inputRW+"\""       
        command=command+", matrix=T"       
        command=command+", sum=T"       
        command=command+", info=T"
        command=command+")"

        run.write(command) 
        print(command)
        run.close() 

        #We run the program - it can be that in windows it doesn't
        os.system('R <' + name + ' --no-save')
    

    def cb(vari):
        x= ("variable is {0}".format(vari.get()))
        
    spin = IntVar()
    spin1 = IntVar()
    rw = Toplevel()
    rw.title("Running Windows Module")
    rw.geometry('200x350')

    mi=IntVar(rw)
    mi.set(67)
    
    spin = Spinbox(rw, from_=0, to=100, width=5,  textvariable=mi)
    spin.grid(column=2,row=3)
    bThr=Label( rw ,  text="Select Threshold")
    bThr.grid(column=0,row=3, pady=10)
    Thr_Q = Label(rw, text="  ?  ", relief="sunken")
    Thr_Q.grid(column=4, row=3)
    Thr_Q_ttp=CreateToolTip(Thr_Q, "The threshold is the minimum number of selected AA codons to appear in a window")
    
    mi=IntVar(rw)
    mi.set(80)
    spin1 = Spinbox(rw, from_=0, to=100, width=5, textvariable=mi)
    spin1.grid(column=2,row=4)
    bWz=Label( rw ,  text="Select Windows Size")
    bWz.grid(column=0,row=4)
    Win_Q = Label(rw, text="  ?  ", relief="sunken")
    Win_Q.grid(column=4, row=4)
    Win_Q_ttp=CreateToolTip(Win_Q, "The Window corresponds to a fragment of the sequence with fixed size that will be sliding")

    baa1=Button( rw ,  text="Select AA Codons", command= lambda: create_cbutsa(aw))
    baa1.grid(column=0,row=5, columnspan=3, padx=10, pady=10, sticky=W+E)
    aw=Label(rw, text="atCod=0")
    Cods_A_Q = Label(rw, text="  ?  ", relief="sunken")
    Cods_A_Q.grid(column=4, row=5)
    Cods_A_Q_ttp=CreateToolTip(Cods_A_Q, "Codons from the AA that want to be studied")
    

    baa1=Button( rw ,  text="Select Affected Codons", command= lambda: create_cbutsd(dw))
    baa1.grid(column=0,row=6, columnspan=3, padx=10, pady=10, sticky=W+E)
    dw=Label(rw, text="dtCod=0")
    Cods_Q = Label(rw, text="  ?  ", relief="sunken")
    Cods_Q.grid(column=4, row=6)
    Cods_Q_ttp=CreateToolTip(Cods_Q, "Codons Affected that want to be selected")

    #FASTA DIR
    rad2 = Button (rw,text='Select FASTA file',command=lambda: select_file(LFasta))
    rad2.grid(column=0,row=1, columnspan=3, padx=10, pady=10, sticky=W+E)
    Fasta_Q=Label(rw, text="  ?  ", relief="sunken")
    Fasta_Q_ttp=CreateToolTip(Fasta_Q, "Fasta file that has to be analized")
    Fasta_Q.grid(row=1, column=4)

    #OUTPUT DIR
    LFasta=Label(rw, text="miau")
    bdestiout=Button( rw,  text="Select output directory", command= lambda: select_dir(LDir))		#ubiquem els botons
    bdestiout.grid(column=0,row=2, columnspan=3, padx=10, pady=10, sticky=W+E)
    LDir=Label(rw, text='miau2')
    Dir_Q=Label(rw, text="  ?  ", relief="sunken")
    Dir_Q_ttp=CreateToolTip(Dir_Q, "Directory where all the outputs will be generated")
    Dir_Q.grid(row=2, column=4)

   
    LEthr=Label(rw, text="Enrichment Threshold")
    LEthr.grid(column=0, row=7)
    mi=IntVar(rw)
    mi.set(0.8)
    Ethr=Spinbox(rw, from_=0.01, to=1.00, width=5, textvariable=mi, increment=0.01, format="%.2f")
    Ethr.grid(column=2, row=7)
    Ethr_Q=Label(rw, text="  ?  ", relief="sunken")
    Ethr_Q_ttp=CreateToolTip(Ethr_Q, "Minimum ratio of affected codons that should appear in a window")
    Ethr_Q.grid(row=7, column=4)
  
    bok11=Button( rw ,  text="Accept and run", command=test)
    bok11.grid(column=0,row=10, columnspan=3, padx=10, pady=30, sticky=W+E)

    rw.mainloop()

path_desti=""                 
def fastacreator():

    def select_IDfile():
        global filenameid
        global selid
        selid=True
        print(selid)
        IDfile = filedialog.askopenfile( initialdir="C:/", title="select CCDS file", filetypes=(("text files", "*.fna"), ("all files", "*.*")))
        filenameid=IDfile.name
        popupmsg('ID FILE selected properly!\n')
        
    def select_CCDSfile():
        global filenameccds
        selccds=True
        CCDSfile = filedialog.askopenfile( initialdir="C:/", title="select CCDS file", filetypes=(("text files", "*.fna"), ("all files", "*.*")))
        filenameccds=CCDSfile.name
        popupmsg('CCDS FILE selected properly!\n')
            
    def select_dir(label):
        global path_desti
        filename = filedialog.askdirectory(title="Select Output Directory")
        label.configure(text=filename)
        path_desti=filename

             
    def creation_fastafile():
       
        if path_desti == "":
            messagebox.showerror("Error", "Please Select Output Directory")
            return None
        try:

            path_to_file = pjoin(path_desti, 'bigFASTAfile.fa')
            f3 = open(path_to_file, "r+")
            f3.close()
            os.remove('bigFASTAfile.fa')
            path_to_file = pjoin(path_desti, 'bigFASTAfile.fa')
            f3 = open(path_to_file, "w")   
        except:

            path_to_file = pjoin(path_desti, 'bigFASTAfile.fa')
            f3 = open(path_to_file, "w")
        
        try:

            path_to_file = pjoin(path_desti, 'smallFASTAfile.fa')
            f35 = open(path_to_file, "r+")
            f35.close()
            os.remove('smallFASTAfile.fa')
            path_to_file = pjoin(path_desti, 'smallFASTAfile.fa')
            f35 = open(path_to_file, "w")
        except:
        
            path_to_file = pjoin(path_desti, 'smallFASTAfile.fa')
            f35 = open(path_to_file, "w")

        try: 
            print(selid)
            if selid==True:
                try:
                    f00 = open(filenameid, 'r')
                except IOError:
                    messagebox.showerror("Error", "Cannot open ID List file!")
                    return None
                for line in f00:
                    line=line.strip()
                    line=line+'\n'
                    text2.insert(tk.END, line)
                t=text2.get(1.0,END)
                        
            #text1.insert(tk.END, "Creating Fasta file please wait...")
            if selid==False:
                t= text2.get(1.0,END)
                if len(t) == 1:
                    messagebox.showerror("Error", "The Uniprot ID list cannot be empty")
                    return None
                #t=t.lstrip()
                   
            if selccds==False:
                try:
                    name=directori+"/Utilities/CCDS_nucleotide.current.fna"
                    tryopen=open(name, "r")
                    tryopen.close()
                except IOError:
                    messagebox.showerror("Error", "Cannot open CCDS source file.")
                    return None
            
            if selccds==True:
                try:
                    miau = open(filenameccds, 'r')
                    miau.close()
                except IOError:
                    messagebox.showerror("Error", "Cannot open CCDS source file.")
                    return None 


            f5 = open('IDuniprotCCDS', 'w+')
            f6 = open('IDuniprotGeneName', 'w+')
            #t=t.strip()
            #print(t)
            #API GOING TO FROM THE ID LIST TO CCDS CODE
            url = "https://www.uniprot.org/uploadlists/"
        
            params = {
            "from": "ACC+ID",
            "to": "CCDS_ID",
            "format": "tab",
            "query": t
            }

            data = urllib.parse.urlencode(params)
            data = data.encode("utf-8")
            req = urllib.request.Request(url, data)
            with urllib.request.urlopen(req) as f:
                response = f.read()
                writee=(response.decode("utf-8"))
                f5.write(writee)
                           
            url = "https://www.uniprot.org/uploadlists/"

            params = {
            "from": "ACC+ID",
            "to": "GENENAME",
            "format": "tab",
            "query": t
            }

            data = urllib.parse.urlencode(params)
            data = data.encode("utf-8")
            req = urllib.request.Request(url, data)
            with urllib.request.urlopen(req) as f:
                response = f.read()
                writee2=(response.decode("utf-8"))
                f6.write(writee2)

            f5.close()
            f6.close()
            
            #PUT IN CORRECT FORMAT FROM LIST TO LIST WITH THE | TO CAN MANIPULATE IT 
            f8 = open('IDuniprotCCDS', 'r')
            f7 = open('IDuniprotGeneName', 'r')
            f9 = open('IDuniprotCCDSbarra', 'w+')
            f10 = open('IDuniprotGeneNamebarra', 'w+')

            for line in f8:
                line=line.strip()
                a,b=line.split()
                f9.write(a+"|"+b+"\n")

            f8.close()
            os.remove('IDuniprotCCDS')
           
            for line in f7:
                a,b=line.split()
                f10.write(a+"|"+b+"\n")

            f7.close()
            os.remove('IDuniprotGeneName')
            f9.close()
            f10.close()

            #CHOSE LARGEONE

            f = open('IDuniprotCCDSbarra', 'r')
            f1 = open('IDuniprotCCDSbarra', 'r')
            f2 = open('IDuniprotCCDSbarra', 'r')
            f30 = open('UnicIDCCDScode', 'w+')
            lines=f.readlines()
            f.close()
            dictionary= {}
            def FASTA_iterator(fasta_filename):
                dicctionary1={}
                """A Generator Function that reads a Fasta file. In each iteration, the function must return a tuple with the following format: (identifier, sequence)."""
                file = open(fasta_filename, "r")
                sequence = ""
                for my_line in file:
                    line = my_line.strip()
                    if line.startswith(">"):
                        if not sequence == "":
                            dicctionary1[name]=sequence
                        name = line[1:].split("|",1)[0]
                        sequence = ""
                    else: 
                        sequence = sequence+"\n" + line
                file.close()
                dicctionary1[name]=sequence
                return dicctionary1
            if selccds==False:
                try:
                    name=directori+"/Utilities/CCDS_nucleotide.current.fna"
                    tryopen=open(name, "r")
                    tryopen.close()
                except IOError:
                    messagebox.showerror("Error", "Cannot open CCDS source file.")
                    return None
                listccds=FASTA_iterator(name)

            if selccds==True:
                listccds=FASTA_iterator(filenameccds)
            

            for line in f1:
                a,b= line.split("|")
                b=b.strip()
                dictionary[a]=(b)
                
            ID=0
            w1=f2.readline()
            f30.write(w1)
            max=len(lines)
            maxs=0
            i=1
            #####
            while i < max:
                a,b=lines[i].split("|")
                b=b.strip()
                ID=a
                if ID in w1:
                    while ID in w1 and i < max :
                        ccds=listccds[b] #EL CCDS HA D'estar
                        canmaxseq=len(ccds)
                        if maxs<canmaxseq:
                            maxs=canmaxseq
                            idmax=ID
                        w1=f2.readline()
                        i=i+1
                        try:
                            a,b=lines[i].split("|")
                            b=b.strip()
                            ID=a
                        except:
                            break
                    idmax=idmax.strip()
                    w=idmax+dictionary[idmax]
                else:
                    w=lines[i]
                    f30.write(w)
                    w1=f2.readline()
                    i=i+1
            print("uwu")       
            f1.close()   
            f2.close()
            f30.close()

            #MARGE TWO LIST CCDS-IDUNIPROT-GENENAME
            f9 = open('UnicIDCCDScode', 'r')
            f10 = open('IDuniprotGeneNamebarra', 'r')
            f11 = open('CCDSIDuniprotGenenamelarge', 'w+')
            f12 = open('IDuniprotCCDSbarra', 'r')
            f13 = open('CCDSIDuniprotGenename', 'w+')
            i=0
            dictionary = {}
            add=0
            gene=0
            for line in f10:
                if line != ('\n'):
                    a,b= line.split('|')
                    dictionary[a]=(b)
            print("aqki")
            for line in f9:
                if line != ('\n'):
                    c,d=line.split('|')
                    c=c.strip()
                    key=c
                    if key in dictionary:
                        value=dictionary[key]
                        line=line.strip()
                        e,f=line.split('|')
                        f11.write(f+'|'+e+'|'+value)
                    else:
                        line=line.strip()
                        e,f=line.split('|')
                        f11.write(f+'|'+e+'|----'+'\n')
            f10.close() 
            f10 = open('IDuniprotGeneNamebarra', 'r')
            for line in f10:
                if line != ('\n'):
                    a,b= line.split('|')
                    dictionary[a]=(b)

            for line in f12:
                if line != ('\n'):
                    c,d=line.split('|')
                    c=c.strip()
                    key=c
                    if key in dictionary:
                        value=dictionary[key]
                        line=line.strip()
                        e,f=line.split('|')
                        f13.write(f+'|'+e+'|'+value)
                    else:
                        line=line.strip()
                        e,f=line.split('|')
                        f13.write(f+'|'+e+'|----'+'\n')
            f9.close()
            f10.close()                    
            f11.close()
            f12.close()
            f13.close()
            print("Done")
            os.remove('IDuniprotCCDSbarra')
            os.remove('IDuniprotGeneNamebarra')
            #FASTA FILE CREATION 
            
            if selccds==False:
                name=directori+"/Utilities/CCDS_nucleotide.current.fna"
                f2 = open(name, 'r')

            if selccds==True:
                f2 = open(filenameccds, 'r')
            
            if selccds==False:
                name=directori+"/Utilities/CCDS_nucleotide.current.fna"
                listccds=FASTA_iterator(name)

            if selccds==True:
            
                listccds=FASTA_iterator(filenameccds)

            i=0
            dictionary3 = {}
            add=0
            gene=0
        
            f4 = open('CCDSIDuniprotGenename', 'r')
            f40 = open('CCDSIDuniprotGenenamelarge', 'r')
            for line in f4:
                if line != ("\n"):
                    a,b,c= line.split('|')
                    dictionary3[a]=(b,c)
            for line in f2:
                    i=i+1
                    char=line[:1]
                    if char == ('>'):
                        gene=gene+1
                        key=line[1:].split('|',1)[0]
                        if line[1:].split("|",1)[0] in dictionary3:
                            values=dictionary3[key]
                            iduni=values[0]
                            genname=values[1]
                            line=line.strip()
                            f3.write(line+'|'+iduni+'|'+genname)
                            add=add+1
                            writee=listccds[key]
                            f3.write(writee+'\n')
                            

            if selccds==False:
                name=directori+"/Utilities/CCDS_nucleotide.current.fna"
                listccds=FASTA_iterator(name)
                print("Done")

            if selccds==True:
                filenameccds
                listccds=FASTA_iterator(filenameccds)
            i=0
            dictionary3 = {}
            add1=0
            gene=0
            f2.close()
            if selccds==False:
                name=directori+"/Utilities/CCDS_nucleotide.current.fna"
                f2 = open(name, 'r')

            if selccds==True:
                f2 = open(filenameccds, 'r')
            
            for line in f40:
                if line != ("\n"):
                    a,b,c= line.split('|')
                    dictionary3[a]=(b,c)
            for line in f2:
                    i=i+1
                    char=line[:1]
                    if char == ('>'):
                        gene=gene+1
                        key=line[1:].split('|',1)[0]
                        if line[1:].split("|",1)[0] in dictionary3:
                            values=dictionary3[key]
                            iduni=values[0]
                            genname=values[1]
                            line=line.strip()
                            f35.write(line+'|'+iduni+'|'+genname)
                            add1=add1+1
                            writee=listccds[key]
                            f35.write(writee+'\n')
            quote1=add
            quote2=add1
            if add==0:
                text1.insert(tk.END, quote1, 'color')
                text1.insert(tk.END, quote2, 'color')
                text1.insert(tk.END, '  IDuniprot added in FASTA   file created\n\n')
                text1.insert(tk.END, 'Please check if the ID introd-uced are valids')
            if add!= 0:

                text1.insert(tk.END, '\n\nFASTA file created! \nPlease check in the directory selected previously \n\n\n')
                text1.insert(tk.END, quote1, 'color')
                text1.insert(tk.END, ' IDuniprot added in big FASTA   file created\n')
                text1.insert(tk.END, quote2, 'color')
                text1.insert(tk.END, ' IDuniprot added in small FASTA   file created')

            f2.close()
            f3.close()
            f4.close()
            f40.close()
            
            os.remove('CCDSIDuniprotGenename')
            os.remove('UnicIDCCDScode')
            os.remove('IDuniprotCCDSbarra')
            os.remove('CCDSIDuniprotGenenamelarge')
            
            popupmsg('FASTA file created, please scroll down the left panel')
                
        except:
            popupmsg('Something is wrong!:(, please scroll down the left panel')
            text1.insert(tk.END, '\n\nSomething is wrong!Suggestions:\n -Please check your internet connection\n-Please make sure the ID do not have any space at the end(is better to copy directly from excel file)\n')
    
    
    window=Toplevel()

    text1 = tk.Text(window, height=20, width=30)
    scroll1 = tk.Scrollbar(window, command=text1.yview)
    window.title ( "Retrieve CCDS Fasta Sequence Module") 

    text1.pack(side=tk.LEFT)

    text1.insert(tk.END,'\nWelcome to Retrieve CCDS Fasta Sequence Module!\n', 'big')
    quote = '\nPlease select first the direc-tory where you want FASTA file to be created using: \n''1.Select creating directory'' \nand then click \n''2. Ok''' 

    text1.insert(tk.END, quote, 'color')

    text1.pack(side=tk.LEFT)
    scroll1.pack(side=tk.LEFT, fill=tk.Y)
    text1.configure(yscrollcommand=scroll1.set)

    text2 = tk.Text(window, height=20, width=50)
    scroll = tk.Scrollbar(window, command=text2.yview)
    text2.configure(yscrollcommand=scroll.set)
    text2.tag_configure('bold_italics', font=('Arial', 16, 'bold', 'italic'))
    text2.tag_configure('big', font=('Verdana', 20, 'bold'))
    text2.tag_configure('color',
                    foreground='#476042',
                    font=('Tempus Sans ITC', 16, 'bold'))
    text2.pack(side=tk.LEFT)
    scroll.pack(side=tk.RIGHT, fill=tk.Y)

    #Escolli directoris font i desti

    escollir = Frame (window)  #cremm frame que contindra botons i labels per escollir els directoris i cercar

	#Botons escollir 

    botons_escollir= Frame (escollir) # creem frame per als botons d'escollir directori

    #Frame labels_escollir+cerca 
    labels_cerca_escollir= Frame (escollir)		#crem frame que tindra el boto de cerca i els labels-frame que mostraran els directoris selecionats

    fldesti= LabelFrame (labels_cerca_escollir)
    ldesti= Label ( fldesti, bg="pink")
    ldesti.pack(expand =TRUE, fill=X)
    fldesti.pack( side = LEFT, expand =TRUE, fill=X)
    botons_escollir.pack( side = LEFT, fill=X)
    labels_cerca_escollir.pack(side =LEFT, expand=TRUE, fill=X)
    escollir.pack(expand=TRUE, fill=X, anchor = NW) 

    bdesti=Button( botons_escollir ,  text="1. Select creation directory", command= lambda: select_dir(ldesti))		#ubiquem els botons
    
    crear= Button (window, text = "Create FASTA file", command= creation_fastafile) 
    bccds=Button(window,  text="Select CCDS file", command= select_CCDSfile)
    bid=Button( window ,  text="Select UniprotID file", command= select_IDfile)
    #run= Button ( root, text = "Run Str Program", command= runp) 
    #creem els botons asociats a la seva funcio

    #bordenar.pack (side =BOTTOM, anchor=SW) #ubiquem els botons al lloc adcuat dins del frame botons_originals
    bid.pack ( side = LEFT)
    bccds.pack ( side = LEFT)
    crear.pack ( side = LEFT)	
    #run.pack (side = LEFT)
    bdesti.pack( fill=X)	
    bdesti.pack(side = LEFT, anchor = E) 

def consecutive():


    def select_dir(label):
        filename = filedialog.askdirectory(title="Select Output Directory")
        label.configure(text=filename)


    def create_cbutsa(label):
        root = Toplevel()
        root.title("a Codons")
        name=directori+"/Utilities/allCodsAA.txt"
        f900=open(name,'r')
        listaa=f900.readlines()
        cbuts_text = listaa
        cbuts = []
        i=0
        j=0
        varis=[]
        for index, item in enumerate(cbuts_text):
            var=IntVar()
            cbuts.append(Checkbutton(root, text = item, variable=var))
            cbuts[index].grid(column=i,row=j, padx=10)
            j=j+1
            if j==4:
                i=i+1
                j=0
            varis.append(var)
        def deselect_all():
                for i in cbuts:
                    i.deselect()

        def select_aTAPS():
                deselect_all()
                listaTAPS=[37,38,39,40,21,22,23,24,5,6,7,8,53,54,55,56]#format R
                for i in listaTAPS: #format P
                    e=RtoP[i]
                    e=e-1
                    cbuts[e].select()  
            
        def select_aLIVR_aTAPS():
                deselect_all()
                listaTAPSLIVR=[37,38,39,40,21,22,23,24,5,6,7,8,53,54,55,56,29,30,31,32,61,63,13,14,16,45,46,47,48,25,26,27,28,9,11] #format R
                for i in listaTAPSLIVR:#format P
                    e=RtoP[i]
                    e=e-1
                    cbuts[e].select()
        
        def select_all():
            for i in cbuts:
                i.select()
            
        def oka():
            yesno=[]
            for i in varis:
                yesno.append(i.get())
            n=0
            rlist=[]
            for i in yesno:
                if i:
                    rlist.append(n)
                n=1+n
            listcod=[]
            for i in rlist:
                listcod.append(codonList[i])
            label.configure(text=listcod)
            root.destroy()

        nba4=Button(root ,  text="I34 (TAPS)", command=select_aTAPS)
        nba4.grid(column=2,row=6)
        nba6=Button(root ,  text="I34", command=select_aLIVR_aTAPS)
        nba6.grid(column=1,row=6)
        nba7=Button(root,  text="Unselect all", command=deselect_all)  
        nba7.grid(column=4,row=6)
        nba9=Button(root,  text="Select all", command=select_all)  
        nba9.grid(column=3,row=6) 
        nba8=Button(root,  text="OK", command=oka)
        nba8.grid(column=5,row=6) 
        mainloop() 
        
    def Consecutive_ok():
        #  MIREM QUE ESTIGUIN TOTES LES COSES NECESARIES

        if SelectCodons['text'] =="":
            messagebox.showerror("Error", "Please select codon set!")
            return None

        if InputDir['text']=="                    ":
            messagebox.showerror("Error", "Please select input directory!")
            return None

        if OutputDir['text']== "                    ":
            messagebox.showerror("Error", "Please select output directory!")
            return None
        
        # ESTAN TOTES LES VARIABLES NECESARIES!

        sel_cods=SelectCodons['text'].split(" ")
        GetConsecutive(InputDir['text'], sel_cods, Min.get(), Max.get(), OutputDir['text'])
        messagebox.showinfo("Finished!", "The analysis is done, you can check the output files!")

    con=Toplevel()
    con.title ( "Get Consecutive Module") 

    InputDir=Label(con, text="                    ", bg="white")
    InputDir.grid(row=1, column=2, columnspan=2)
    Input= Button(con, text="Select Input Directory", command=lambda: select_dir(InputDir))
    Input.grid(row=1, column= 1)

    OutputDir=Label(con, text="                    ", bg="white")
    OutputDir.grid(row=2, column=2, columnspan=2, pady=20)
    Output= Button(con, text="Select Output Directory", command=lambda: select_dir(OutputDir))
    Output.grid(row=2, column= 1, pady=20)

    SelectCodons=Label(con, text="")
    SelButton=Button(con, text="Select Codon Set", command= lambda:create_cbutsa(SelectCodons))
    SelButton.grid(row=4, column=1, pady=40)

    Min=IntVar(con)
    Min.set(5)
    spin = Spinbox(con, from_=0, to=100, width=5,  textvariable=Min)
    spin.grid(column=2,row=5, pady=20)
    bMin=Label( con ,  text="Select Minimum Number \nof Consecutive Codons")
    bMin.grid(column=1,row=5, pady=20)

    Max=IntVar(con)
    Max.set(3)
    spin1 = Spinbox(con, from_=0, to=100, width=5,  textvariable=Max)
    spin1.grid(column=2,row=6, pady=20)
    bMax=Label( con ,  text="Select Maximum Number \nof Codon Separation")
    bMax.grid(column=1,row=6, pady=20)

    OKButton=Button(con, text="Start the Analysis!", command= Consecutive_ok)
    OKButton.grid(row=7, column= 2, sticky=W+E)



def ocurrences():
    def select_dir(label):
        filename = filedialog.askdirectory(title="Select Output Directory")
        label.configure(text=filename)


    def create_cbutsa(label):
        root = Toplevel()
        root.title("a Codons")
        name=directori+"/Utilities/allCodsAA.txt"
        f900=open(name,'r')
        listaa=f900.readlines()
        cbuts_text = listaa
        cbuts = []
        i=0
        j=0
        varis=[]
        for index, item in enumerate(cbuts_text):
            var=IntVar()
            cbuts.append(Checkbutton(root, text = item, variable=var))
            cbuts[index].grid(column=i,row=j, padx=10)
            j=j+1
            if j==4:
                i=i+1
                j=0
            varis.append(var)
        def deselect_all():
                for i in cbuts:
                    i.deselect()

        def select_aTAPS():
                deselect_all()
                listaTAPS=[37,38,39,40,21,22,23,24,5,6,7,8,53,54,55,56]#format R
                for i in listaTAPS: #format P
                    e=RtoP[i]
                    e=e-1
                    cbuts[e].select()  
            
        def select_aLIVR_aTAPS():
                deselect_all()
                listaTAPSLIVR=[37,38,39,40,21,22,23,24,5,6,7,8,53,54,55,56,29,30,31,32,61,63,13,14,16,45,46,47,48,25,26,27,28,9,11] #format R
                for i in listaTAPSLIVR:#format P
                    e=RtoP[i]
                    e=e-1
                    cbuts[e].select()
        
        def select_all():
            for i in cbuts:
                i.select()
            
        def oka():
            yesno=[]
            for i in varis:
                yesno.append(i.get())
            n=0
            rlist=[]
            for i in yesno:
                if i:
                    rlist.append(n)
                n=1+n
            listcod=[]
            for i in rlist:
                listcod.append(codonList[i])
            label.configure(text=listcod)
            root.destroy()

        nba4=Button(root ,  text="I34 (TAPS)", command=select_aTAPS)
        nba4.grid(column=2,row=6)
        nba6=Button(root ,  text="I34", command=select_aLIVR_aTAPS)
        nba6.grid(column=1,row=6)
        nba7=Button(root,  text="Unselect all", command=deselect_all)  
        nba7.grid(column=4,row=6)
        nba9=Button(root,  text="Select all", command=select_all)  
        nba9.grid(column=3,row=6) 
        nba8=Button(root,  text="OK", command=oka)
        nba8.grid(column=5,row=6) 
        mainloop() 
        
    def Consecutive_ok():
        #  MIREM QUE ESTIGUIN TOTES LES COSES NECESARIES

        if SelectCodons['text'] =="":
            messagebox.showerror("Error", "Please select codon set!")
            return None

        if InputDir['text']=="                    ":
            messagebox.showerror("Error", "Please select input directory!")
            return None

        if OutputDir['text']== "                    ":
            messagebox.showerror("Error", "Please select output directory!")
            return None
        
        # ESTAN TOTES LES VARIABLES NECESARIES!

        sel_cods=SelectCodons['text'].split(" ")
        GetUsage(InputDir['text'],sel_cods,OutputDir['text'])
        messagebox.showinfo("Finished!", "The analysis is done, you can check the output files!")

    usage=Toplevel()
    usage.title ( "Get Get Codon Usage Module")
    usage.geometry("400x225")


    InputDir=Label(usage, text="                    ", bg="white")
    
    Input= Button(usage, text="Select Input Directory", command=lambda: select_dir(InputDir))
    Input.pack(pady=10)
    InputDir.pack(fill=X)

    OutputDir=Label(usage, text="                    ", bg="white")
    Output= Button(usage, text="Select Output Directory", command=lambda: select_dir(OutputDir))
    Output.pack(pady=10)
    OutputDir.pack(fill=X)

    SelectCodons=Label(usage, text="")
    SelButton=Button(usage, text="Select Codon Set", command= lambda:create_cbutsa(SelectCodons))
    SelButton.pack( pady=10)


    OKButton=Button(usage, text="Start the Analysis!", command= Consecutive_ok)
    OKButton.pack(fill=X, pady=10)


def fastamaker():

    def select_dir(label):
        filename = filedialog.askdirectory(title="Select Output Directory")
        label.configure(text=filename)

    def fastamaker_ok():

        #MIREM QUE TOTES LES VARIABLES ESTIGUIN OK
        #el text
        t= text2.get(1.0,END)
        if len(t) == 1:
            messagebox.showerror("Error", "The Uniprot ID list cannot be empty")
            return None
        ids=t.replace("\n", " ")

        if DestiDir['text']== "":
            messagebox.showerror("Error", "Please select output directory!")
            return None
        
        message=GetFasta(ids, DestiDir['text'])
        messagebox.showinfo("Finished", message)
        


    fasta=Toplevel()
    text1=Label(fasta, text="Please paste the list of Uniprot IDs in thw white box below, and select the output directory.")
    text1.pack(anchor=NW)
    text2 = tk.Text(fasta, height=20, width=30)
    scroll = tk.Scrollbar(fasta, command=text2.yview)
    text2.configure(yscrollcommand=scroll.set)
    text2.pack(side=LEFT)
    scroll.pack(side=RIGHT, fill=tk.Y)

    Espai=Frame(fasta)
    Espai.pack(side=RIGHT, fill=Y, expand=1)
    DestiDir=Label(Espai, text="", bg="white")
    BDestiDir=Button(Espai, text= "Select output Directory", command=lambda: select_dir(DestiDir))
    
    BDestiDir.pack(padx=10, fill=X, pady=10)
    DestiDir.pack(fill=X, padx=10, pady=10)

    Start=Button(Espai, text="Start the analysis!", command=fastamaker_ok)
    Start.pack(anchor=SE, fill= X, expand=1)
    

def linkHelp():
    webbrowser.open_new("http://www.google.com")

def linkIDConversion():
    webbrowser.open_new("https://biodbnet-abcc.ncifcrf.gov/db/db2db.php")

def linkDavid():
    webbrowser.open_new("https://david.ncifcrf.gov/")


root = tk.Tk()
root.title('StretchFinder')
root.geometry('600x400')

menubar=Menu(root)

filemenu=Menu(menubar)
filemenu.add_command(label="Retrieve CCDS Fasta Sequence Module", command=fastacreator)
filemenu.add_command(label="Retrieve Fasta Sequence Module", command=fastamaker)
filemenu.add_command(label="Running Windows Module", command=runp)
filemenu.add_command(label="Get Consecutive Module", command=consecutive)
filemenu.add_command(label="Get Codon Usage Module", command=ocurrences)

filemenu.add_separator()
filemenu.add_command(label='Quit', command=root.quit)

helpmenu=Menu(menubar)
helpmenu.add_command(label="ID Conversion Tool", command=linkIDConversion)
helpmenu.add_command(label="DAVID Bioinformatics Resources", command=linkDavid)
helpmenu.add_command(label="Help", command=linkHelp)

menubar.add_cascade(label='Tools', menu=filemenu)
menubar.add_cascade(label='Online Tools', menu=helpmenu)

root.config(menu=menubar)

TextInitial=Label(root, text="Welcome to StretchFinder")
TextInitial.config(width=200)
TextInitial.config(font=("Verdana", 20))
TextInitial.pack()


MainText=Label(root, text=" \n \n StretchFinder is a set of tools to help users with their genomic analyses. \n You can find them in the Tools section in the menu bar. \n \n \n \n If you have any problems please contanct: helena.96.14@gmail.com")
MainText.config(font=("Verdana", 11))
MainText.pack()
root.mainloop()
