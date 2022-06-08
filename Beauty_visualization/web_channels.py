# Instituto Nacional de Astrofisica Optica y Electronica Mx.
# Dep. de Ciencias de la computacion
# Alejandra Rocha Solache


#Log: 9-feb-2022 @arocha : File creation
import pandas as pd
import numpy as np
import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import chart_studio
username = "rochasolache"
api_key ='abtA3JrpQUvWsIGfaiAk'

chart_studio.tools.set_credentials_file(username=username, api_key=api_key)
import chart_studio.plotly as py
import chart_studio.tools as tools



#["plotly", "plotly_white", "plotly_dark", "ggplot2", "seaborn", "simple_white", "none"]
theme= "plotly_white"


# Plot de los canales simulados
channels = np.genfromtxt("channels_data.csv", delimiter=',')
channels = pd.DataFrame(data={'Ch1':channels[:,0],
                                     'Ch2':channels[:,1],
                                     'Ch3':channels[:,2],
                                     'Ch4':channels[:,3],
                                     'Ch5':channels[:,4],
                                     'Ch6':channels[:,5],
                                     'Ch7':channels[:,6],
                                     'Ch8':channels[:,7]})

# Plot scatter 3d - (PHASE & TIME)
#plotchannels = px.area(channels)
#py.plot(plotchannels, filename="channels", auto_open=True)

# Manifold completo

events_cubinder = np.genfromtxt("gridManifold.csv", delimiter=',')
events_cubinder = pd.DataFrame(data={'Cos(Phase)':events_cubinder[:,0],
                                     'Sin(Phase)':events_cubinder[:,1],
                                     'Phase':events_cubinder[:,2],
                                     'Frequency':events_cubinder[:,3],
                                     'Time':events_cubinder[:,4]})

# Plot scatter 3d - (PHASE & FREQ)
fig = px.scatter_3d(events_cubinder, x='Sin(Phase)', y='Cos(Phase)', z='Frequency',
                    color='Frequency',
                    template=theme,
                    title="Cubinder 3D view",
                    labels={
                     "sen_phase": "Sin (Phase)",
                     "cos_phase": "Cos (Phase)",
                     "event_frequency": "Frequency"})
py.plot(fig, filename="testing", auto_open=True )
fig.show()
