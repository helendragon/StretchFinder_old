import os
from operator import itemgetter
import urllib
import urllib.parse
import urllib.request
import requests
import sys
import re
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

def GetConsecutive (FastaDir, CodonList, ConsecutiveMinimum, MaxSeparation, OutputDir):
    
    '''
    This function looks for stretches of consecutive sets of codons.
    The inputs are: A fasta file or folder with fasta files; The codon list that you want; the minimum number of codons to be a stretch; and the maximum separation between stretches; and the output directory
    The outputs are 2 csv files, one with all the stretches and another with the longest stretch of each gene. 
    '''
    #Creem les carpetes dels resultats
    OutputDir=OutputDir.replace("\\", "/")
    outputALL = open(OutputDir+"/All_Consecutive.csv", "w")
    outputUni = open(OutputDir+"/Unique_Consecutive.csv", "w")
    endCod=["TAG", "TAA", "TGA"]
    wantCods=CodonList
    stretch=[]
    count=1

    #Creem la primera linia del output
    outputALL.write("File;Gene Name; Length Stretch;")
    outputUni.write("File;Gene Name; Length Stretch;")
    for codon in wantCods:
        outputALL.write(codon+";")
        outputUni.write(codon+";")
    outputALL.write("Length Gene; Position\n")
    outputUni.write("Length Gene; Position\n")
    

    #Creem una llista amb el path les files que volem analitzar
    carpetes=[]
    if os.path.isdir(FastaDir): #el path es un directori amb les fastes dintre
        Llista_Car=os.listdir(FastaDir)
        for file in Llista_Car:
            carpetes.append(FastaDir+"/"+ file)
    else: #El path es una fasta file
        carpetes.append(FastaDir)

    #Contem els codons consecutius
    sequence = ""
    for fasta in carpetes:
        f= open(fasta, "r")
        for my_line in f:
            line = my_line.strip()
            if line.startswith(">"):
                if not sequence == "":
                    end=sequence[-3:]
                    if sequence.startswith("ATG") and (end in endCod) and (len(sequence)%3 == 0): #que la seq siqui correcta
                        llargadastretches=[]
                        NewStretchList=[]
                        for i in range(0,len(sequence),3):
                            if (sequence[i+3:i+6] in wantCods) and (sequence[i:i+3] in wantCods): #mirem de 3 en 3 si son consecutius
                                count+=1
                                stretch.append(sequence[i:i+3])
                            else :
                                if sequence[i:i+3] in wantCods:
                                    stretch.append(sequence[i:i+3]) #afegim el ultim codo a la llista de stretch
                                    position=i+3
                                if len(stretch) > ConsecutiveMinimum:
                                    save=(stretch, len(stretch), position)
                                    llargadastretches.append(save) #guardem la llargada del stretch i el stretch
                                count=1
                                stretch=[]

                        #sha acbat la sequencia i tenim tots els stretches
                        #Mirem no tenir stretches consecutius
                        if len(llargadastretches)>1:
                            for x in llargadastretches:
                                index=llargadastretches.index(x)
                                try:
                                    y=llargadastretches[index+1]
                                    resta=(y[2] - len(y[0])*3) - x[2]
                                    if resta < MaxSeparation*3:
                                        newStretch= x[0] + y[0]
                                        newSize=len(newStretch)
                                        newPos=y[2]
                                        save=(newStretch, newSize, newPos)
                                        NewStretchList.append(save)
                                        llargadastretches.remove(y)
                                    else:
                                        NewStretchList.append(x)
                                except:
                                    NewStretchList.append(x)
                                

                        #printegem els stretches al ALL
                        for stretch_item in NewStretchList:
                            stretch=stretch_item[0]
                            position=stretch_item[2]
                            outputALL.write(fasta+";"+name+";")
                            outputALL.write(str(len(stretch))+";")

                            for codon in wantCods:
                                cod=stretch.count(codon)
                                outputALL.write(str(cod)+";")
                            outputALL.write(str(len(sequence))+ ";" + str(position/len(sequence))+"\n")

                        #printegem els stretches al Unique
                        outputUni.write(fasta+";"+name+";")
                        if len(NewStretchList) != 0:
                            longest= max(NewStretchList,key=itemgetter(1))
                            position=longest[2]
                            outputUni.write(str(len(longest[0]))+";")

                            for codon in wantCods:
                                cod=longest[0].count(codon)
                                outputUni.write(str(cod)+";")
                            outputUni.write(str(len(sequence))+ ";" + str(position/len(sequence))+"\n")                     
                name = line[1:]
                sequence = ""
            else: 
                sequence = sequence + line
        f.close()
        end=sequence[-3:]
        if sequence.startswith("ATG") and (end in endCod) and (len(sequence)%3 == 0): #que la seq siqui correcta
            llargadastretches=[]
            NewStretchList=[]
            for i in range(0,len(sequence),3):
                if (sequence[i+3:i+6] in wantCods) and (sequence[i:i+3] in wantCods): #mirem de 3 en 3 si son consecutius
                    count+=1
                    stretch.append(sequence[i:i+3])
                else :
                    if sequence[i:i+3] in wantCods:
                        stretch.append(sequence[i:i+3]) #afegim el ultim codo a la llista de stretch
                        position=i+3
                    if len(stretch) > ConsecutiveMinimum:
                        save=(stretch, len(stretch), position)
                        llargadastretches.append(save) #guardem la llargada del stretch i el stretch
                    count=1
                    stretch=[]

            #sha acbat la sequencia i tenim tots els stretches
            #Mirem no tenir stretches consecutius
            if len(llargadastretches)>1:
                for x in llargadastretches:
                    index=llargadastretches.index(x)
                    try:
                        y=llargadastretches[index+1]
                        resta=(y[2] - len(y[0])*3) - x[2]
                        if resta < MaxSeparation*3:
                            newStretch= x[0] + y[0]
                            newSize=len(newStretch)
                            newPos=y[2]
                            save=(newStretch, newSize, newPos)
                            NewStretchList.append(save)
                            llargadastretches.remove(y)
                        else:
                            NewStretchList.append(x)
                    except:
                        NewStretchList.append(x)
                    

            #printegem els stretches al ALL
            for stretch_item in NewStretchList:
                stretch=stretch_item[0]
                position=stretch_item[2]
                outputALL.write(fasta+";"+name+";")
                outputALL.write(str(len(stretch))+";")

                for codon in wantCods:
                    cod=stretch.count(codon)
                    outputALL.write(str(cod)+";")
                outputALL.write(str(len(sequence))+ ";" + str(position/len(sequence))+"\n")

            #printegem els stretches al Unique
            outputUni.write(fasta+";"+name+";")
            if len(NewStretchList) != 0:
                longest= max(NewStretchList,key=itemgetter(1))
                position=longest[2]
                outputUni.write(str(len(longest[0]))+";")

                for codon in wantCods:
                    cod=longest[0].count(codon)
                    outputUni.write(str(cod)+";")
                outputUni.write(str(len(sequence))+ ";" + str(position/len(sequence))+"\n")
    outputALL.close()
    outputUni.close()  
    ################## DATA VISUALIZATION #######################
    all_df= pd.read_csv(OutputDir+"/All_Consecutive.csv", sep=';')
    print(all_df)

    #Histograma de stretch length
    lengths=all_df.iloc[:, 2].tolist() #llista amb els lengths
    
    plot1 = plt.figure(1)
    plt.hist(lengths, bins=50)
    plt.ylabel('Frequency')
    plt.xlabel('Length of the Stretch')
    plt.suptitle('Distribution of Stretch Lengths', fontsize=20)

    # StretchLength vs Position
    plot2 = plt.figure(2)
    position=all_df.iloc[:,-1].tolist() #llista amb les posicions
    plt.scatter(position, lengths)
    plt.ylabel('Stretch Length')
    plt.xlabel('Position')
    plt.suptitle('Stretch Length vs Position', fontsize=20)

    #StretchLength vs Gene length
    plot3=plt.figure(3)
    gene_length=all_df.iloc[:,-2].tolist() #llista amb els lengths
    plt.scatter(gene_length, lengths)
    plt.ylabel('Stretch Length')
    plt.xlabel('Gene Length')
    plt.suptitle('Stretch Length vs Gene Length', fontsize=20)

    #Bar plot codons
    plot4=plt.figure(4)
    mean=all_df.mean()
    test=mean.tolist()
    test=test[1:]
    test=test[:-2]
    y_pos = np.arange(len(wantCods))
    plt.bar(y_pos, test)
    plt.xticks(y_pos, wantCods)
    plt.suptitle('Abundance of the Codons', fontsize=20)
    plt.xlabel('Codons', fontsize=18)
    plt.ylabel('Codon Count in the Stretches', fontsize=16)

    #Show PLots
    plt.show()


def GetUsage (FastaDir, CodonList, OutputDir):
    '''
    This counts the occurences of codons in a fasta file. Gives you the relative abundance!
    The inputs are: A fasta file or folder with fasta files; The codon list that you want; and the output directory
    The outputs a CSV file with the counts of codons, the total counts and the length of the sequence. 
    '''
    #Creem les carpetes dels resultats
    OutputDir=OutputDir.replace("\\", "/")
    outputALL = open(OutputDir+"/CodonUsage.csv", "w")
    endCod=["TAG", "TAA", "TGA"]
    wantCods=CodonList

    #Creem la primera linia del output
    outputALL.write("File;Gene Name;")
    for codon in wantCods:
        outputALL.write(codon+";")
    outputALL.write("Total Count;Length Gene (Codons)\n")
   
    #Creem una llista amb el path les files que volem analitzar
    carpetes=[]
    if os.path.isdir(FastaDir): #el path es un directori amb les fastes dintre
        Llista_Car=os.listdir(FastaDir)
        for file in Llista_Car:
            carpetes.append(FastaDir+"/"+ file)
    else: #El path es una fasta file
        carpetes.append(FastaDir)

    #Contem els codons consecutius
    sequence = ""
    for fasta in carpetes:
        f= open(fasta, "r")
        for my_line in f:
            line = my_line.strip()
            if line.startswith(">"):
                if not sequence == "":
                    sequence=sequence.upper()
                    end=sequence[-3:]
                    if sequence.startswith("ATG") and (end in endCod) and (len(sequence)%3 == 0): #que la seq siqui correcta
                        splitseq=[]
                        for i in range(0,len(sequence),3): #Guardem la sequencia en una llista per codons
                            splitseq.append(sequence[i:i+3])
                        outputALL.write(fasta+";"+name+";")
                        for codon in wantCods:
                            cod=splitseq.count(codon)
                            cod=cod*100
                            rel=cod/len(splitseq)
                            outputALL.write(str(rel)+";")
                        count=0
                        for codon in splitseq:
                            if codon in wantCods:
                                count= count+1
                        outputALL.write(str(count)+";"+str(len(splitseq))+"\n")
                name = line[1:]
                sequence = ""
            else: 
                sequence = sequence + line
        f.close()
        sequence=sequence.upper()
        end=sequence[-3:]
        if sequence.startswith("ATG") and (end in endCod) and (len(sequence)%3 == 0): #que la seq siqui correcta
            splitseq=[]
            for i in range(0,len(sequence),3): #Guardem la sequencia en una llista per codons
                splitseq.append(sequence[i:i+3])
            outputALL.write(fasta+";"+name+";")
            for codon in wantCods:
                cod=splitseq.count(codon)
                cod=cod*100
                rel=cod/len(splitseq)
                outputALL.write(str(rel)+";")
            count=0
            for codon in splitseq:
                if codon in wantCods:
                    count= count+1
            outputALL.write(str(count)+";"+str(len(splitseq))+"\n")
    outputALL.close()

    #Creem els grafics

    #preparem les dades per posarles al matplotlib
    all_df= pd.read_csv(OutputDir+"/CodonUsage.csv", sep=';')
    #print(all_df)
    mean=all_df.mean()
    #print(mean)
    test=mean.tolist() #els means de totes les columnes en format llista!
    test=test[:-2]

    #fem el grafic

    y_pos = np.arange(len(wantCods))
    
    # Create bars
    plt.bar(y_pos, test)
    
    # Create names on the x-axis
    plt.xticks(y_pos, wantCods)
    plt.suptitle('Relative Abundance of the Codons', fontsize=20)
    plt.xlabel('Codons', fontsize=18)
    plt.ylabel('Relative Abundance', fontsize=16)
    # Show graphic
    plt.show()

def GetFasta(listUni, directoriOut):
    
    '''
    This functions reads a string of uniprot IDs separated by spaces, then converts them into their Ensembl ID and retrives the longest cds sequence of this protein. 
    The input are the list of uniprot IDs and the outpur directory.
    The output are the fasta file, and a file with the IDs that were not retrieved or not found. 
    '''

    directoriOut=directoriOut.replace("\\", "/")

    url = "https://www.uniprot.org/uploadlists/"

    #listUni="mlem   P40926 O43175 Q9UM73 P97793 Q9H9K5" #String dels IDS separats per espais!
    ListALL=listUni.split(" ")

    params = {
        "from": "ACC+ID",
        "to": "ENSEMBL_ID",
        "format": "tab",
        "query": listUni
    }
    OutputConversion = open(directoriOut+'/Conversion.txt', 'w+')
    data = urllib.parse.urlencode(params)
    data = data.encode("utf-8")
    req = urllib.request.Request(url, data)
    with urllib.request.urlopen(req) as f:
        response = f.read()
        writee=(response.decode("utf-8"))
        OutputConversion.write(writee)
    OutputConversion.close()

    f=open(directoriOut+"/Conversion.txt", "r")

    ConversionDictionary={}
    for line in f:
        line=line.strip()
        col= line.split("\t")
        ConversionDictionary[col[0]]=col[1]
    f.close()
    #eliminar el conversion

    #Tenim el ID convertit, ara el convertirem a fasta i els que no hem trobat el posarem en una altre file. 

    outputFasta=open(directoriOut+"/output.fa", "w")
    ListNotConverted=[] #els que no ha convertit
    ListNotFound=[] #els que no hem trobat
    server = "https://rest.ensembl.org"
    
    for gene in ListALL:
        ext = "/sequence/id/"
        if gene not in ConversionDictionary:
            ListNotConverted.append(gene)
        else:
            ext=ext+ConversionDictionary[gene]+"?type=cds;multiple_sequences=1"
            r = requests.get(server+ext, headers={ "Content-Type" : "text/plain"}) ## CCDS
            if not r.ok:
                ListNotConverted.append()
                continue
            split=r.text.split("\n")
            longest= max(split, key=len)
            #creem el fasta
            outputFasta.write(">"+ gene+"|"+ConversionDictionary[gene]+"\n")
            outputFasta.write(longest+"\n")
    outputFasta.close()
    #Si hi ha errors

    if (len(ListNotConverted) ==0) and (len(ListNotFound)==0): #esta tot bé
        message= "Everything was found and converted succesfully!"
    elif (len(ListNotConverted)!=0) and (len(ListNotFound)==0): #No ho ha convertit tot, pero ho ha trobat tot
        dif=len(ListALL)-len(ListNotConverted)
        message="Only converted "+str(dif)+ " of IDs succesfully. The Fasta retrieval was correct. The IDs that were not converted are in the text file NotConverted.txt"
        Save=open(directoriOut+"/NotConverted.txt", "w")
        for item in ListNotConverted:
            Save.write(item+"\n")
        Save.close()
    elif (len(ListNotConverted)==0) and (len(ListNotFound)!=0): # Ho ha convertit tot, pero no ha trobat totç
        dif=len(ListALL)-len(ListNotFound)
        message="Only retrieved "+str(dif)+ " of Fasta sequences. The ID conversion was correct. The IDs that were not retrieved are in the text file NotFound.txt"
        Save=open(directoriOut+"/NotFound.txt", "w")
        for item in ListNotFound:
            Save.write(item+"\n")
        Save.close()
    elif (len(ListNotConverted)!=0) and (len(ListNotFound)!=0):
        dif=len(ListALL)-len(ListNotFound)-len(ListNotConverted)
        message="Only retrieved and converted"+str(dif)+ " of Fasta sequences succesfully. There were problems with some IDs or Sequences. The problematic IDs are in the text file Problems.txt"
        Save=open(directoriOut+"/Problems.txt", "w")
        for item in ListNotFound:
            Save.write(item+"\n")
        for item in ListNotConverted:
            Save.write(item+"\n")
        Save.close()
    return(message)
