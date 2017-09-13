from notebook.auth import passwd 
import os

jupyter_config = os.path.expanduser('~/.jupyter/jupyter_notebook_config.py')
line = "==========================================================================="

print(line)
print("Setting Jupyter additional configuration")
print(line)
print("Please set a strong password")
pwhash = passwd()
print(line)
print("Following will be added to %s " % (jupyter_config))

configs = [
    "c.NotebookApp.password = u'%s'" % (pwhash),
    "c.NotebookApp.open_browser = False",
    "c.NotebookApp.ip = '*'",
    "c.NotebookApp.notebook_dir = u'/root/'"
]
print(" ")
_ = [print(z) for z in configs]

print(line)

with open(jupyter_config, 'a') as file:
    file.write('\n')
    _ = [file.write(z +'\n') for z in configs]