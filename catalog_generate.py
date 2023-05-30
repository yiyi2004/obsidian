import os

def generateCatalog():
    for root, dirs, files in os.walk("."):
        print(type(dirs))
        

if __name__ == '__main__':
    generateCatalog()