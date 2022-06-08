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


# Load the events generated in matlab , save them in a dataframe and plot wit plotly
# dataframe(1,:) : event_id
# dataframe(2,:) : senx
# dataframe(3,:) : cosx
# dataframe(4,:) : event_phase
# dataframe(5,:) : event_frequency
# dataframe(6,:) : event_ftime



events_cubinder = np.genfromtxt("../Outputs/Dataframes/dataframe_events_cubinder.csv", delimiter=',')
events_cubinder = pd.DataFrame(data={'event_id':events_cubinder[:,0],
                              'sen_phase':events_cubinder[:,1],
                              'cos_phase':events_cubinder[:,2],
                              'event_phase':events_cubinder[:,3],
                              'event_frequency':events_cubinder[:,4],
                              'event_ftime':events_cubinder[:,5],
                              'causal_cone':events_cubinder[:,6]})

# Only causality cone
events_cubinder = events_cubinder.loc[events_cubinder['causal_cone'] <= 0]


# Plot scatter 3d - (PHASE & TIME)
fig = px.scatter_3d(events_cubinder, x='sen_phase', y='cos_phase', z='event_ftime',
                    color='causal_cone',
                    template=theme,
                    title="Cubinder 3D view",
                    labels={
                     "sen_phase": "Sin (phase)",
                     "cos_phase": "Cos (phase)",
                     "event_ftime": "Time"},)
fig.show()

# Plot scatter 3d - (PHASE & FREQ)                         
fig = px.scatter_3d(events_cubinder, x='sen_phase', y='cos_phase', z='event_frequency',
                    color='causal_cone',
                    template=theme,
                    title="Cubinder 3D view",
                    labels={
                     "sen_phase": "Sin (phase)",
                     "cos_phase": "Cos (phase)",
                     "event_frequency": "Frequency"})
py.plot(fig, filename="testing", auto_open=True )
fig.show()

# Plot scatter 3d - (TIME & FREQ)
fig = px.scatter_3d(events_cubinder, x='event_frequency', y='event_ftime', z='event_phase',
                    color='causal_cone',
                    template=theme,
                    title="Cubinder 3D view",
                    labels={
                     "event_frequency": "Frequency",
                     "event_ftime": "Time",
                     "event_phase": "Phase"})


fig.show()


# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# Ploteando la proyeccion de distancias cdm scale  [ Senosoidales ]

distances_matrix = np.genfromtxt("../Outputs/Dataframes/senosoidal_matrix_distances.csv", delimiter=',')
fig = px.imshow(distances_matrix)
fig.show()

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# Ploteando la proyeccion de distancias cdm scale  [ Senosoidales ]

distances_cubinder = np.genfromtxt("../Outputs/Dataframes/dataframe_distances_cdmscale.csv", delimiter=',')
distances_cubinder = pd.DataFrame(data={'X':distances_cubinder[:,0],
                              'Y':distances_cubinder[:,1],
                              'Z':distances_cubinder[:,2],
                              'W':distances_cubinder[:,3],})
# Plot scatter 3d - (DIFERENCIAS EN FASE - FRECUENCIA Y TIEMPO)                         
fig = px.scatter_3d(distances_cubinder, x='X', y='Y', z='Z',
                    color='W',
                    template=theme)
fig.show()

