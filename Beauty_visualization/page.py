import chart_studio
username = "my_name"
apy_key ='my_key'

chart_studio.tools.set_credentials_file(username=username, api_key=api_key)
import chart_studio.plotly as py
import chart_studio.tools as tools

