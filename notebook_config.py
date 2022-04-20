# sed '/^#\|^$/d' ~/.jupyter/jupyter_notebook_config.py
c.Application.log_datefmt = '%Y-%m-%d %H:%M:%S'
c.Application.log_format = '[%(name)s]%(highlevel)s %(message)s'
c.Application.log_level = 'INFO'
c.JupyterApp.answer_yes = True
c.JupyterApp.log_datefmt = '%Y-%m-%d %H:%M:%S'
c.JupyterApp.log_format = '[%(name)s]%(highlevel)s %(message)s'
c.JupyterApp.log_level = 'INFO'
c.NotebookApp.answer_yes = True
c.NotebookApp.log_format = '[%(name)s]%(highlevel)s %(message)s'
c.NotebookApp.log_level = 'INFO'
c.NotebookApp.password = '<set pwd>'
c.ResourceUseDisplay.mem_limit = 25560088576
c.ResourceUseDisplay.track_cpu_percent = True
c.ResourceUseDisplay.cpu_limit = 12
c.NotebookApp.password_required = True
c.NotebookApp.port = 8888

# sed '/^#\|^$/d' ~/.ipython/profile_default/ipython_config.py 
c.InteractiveShellApp.exec_lines = ['%autoreload 2']
c.InteractiveShellApp.extensions = ['autoreload']
