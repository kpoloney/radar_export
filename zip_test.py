# Test if zip files can be opened
import zipfile
import os

problem = list()

for filename in os.listdir(os.getcwd()):
    if not filename.endswith(".zip"): continue
    else:
        try:
            z = zipfile.ZipFile(filename)
            z.testzip()
            z.close()
        except:
            problem.append(filename)

print(problem)   
 
