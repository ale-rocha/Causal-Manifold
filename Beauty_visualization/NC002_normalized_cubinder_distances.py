
# Instituto Nacional de Astrofisica Optica y Electronica Mx.
# Dep. de Ciencias de la computacion
# Alejandra Rocha Solache

#Log: 16-feb-2022 @arocha : File creation

import plotly.graph_objects as go
from plotly.subplots import make_subplots
import pandas as pd
import numpy as np


def diff_of_distances (distances):

    for i in range(0,distances.shape[0],1):
        all_vars = []
        for j in range(1,distances.shape[1],1):
          c = round(abs(distances[i,j] - distances[i,j-1]),2)
          all_vars.append(c)
        print(all_vars)


# Initialize figure with subplots
fig = make_subplots(
    rows=2, cols=2,
    column_widths=[0.6, 0.4],
    row_heights=[0.4, 0.4],
    subplot_titles=("Cubinder - (Phase, freq view)",
                    'Distance function',
                    "CDMScale (Phase)- 2 dimensions"),
    specs=[[{"type": "scatter3d", "rowspan": 2}, {"type": "scatter"}],
          [            None                    , {"type": "scatter3d"}]])


# read cubinder --------------------------------------------------------------------------------
events_cubinder = np.genfromtxt("../Outputs/Dataframes/NC002_events_cubinder.csv", delimiter=',')
events_cubinder = pd.DataFrame(data={'event_id':events_cubinder[:,0],
                              'sen_phase':events_cubinder[:,1],
                              'cos_phase':events_cubinder[:,2],
                              'event_phase':events_cubinder[:,3],
                              'event_frequency':events_cubinder[:,4],
                              'event_ftime':events_cubinder[:,5]})

fig.add_trace(
    go.Scatter3d(x=events_cubinder["sen_phase"],y=events_cubinder["cos_phase"],z=events_cubinder["event_ftime"]),
    row=1, col=1
)

# read cubinder --------------------------------------------------------------------------------
diffs = np.genfromtxt("../Outputs/Dataframes/NC002_matrix_distances_phase_time.csv", delimiter=',')
nevent = np.arange(0,diffs.shape[0],1)
print(diffs.shape)
fig.add_trace(
    go.Scatter(x=nevent,y=diffs[0,:],
    mode="markers",
    showlegend=False,
    marker=dict(color="crimson", size=4, opacity=0.8) ),
    row=1, col=2
)

#diff_of_distances (diffs)


cdmprojection = np.genfromtxt("../Outputs/Dataframes/dataframe_distances_cdmscale-PHASE-TIME.csv", delimiter=',')
cdmprojection = pd.DataFrame(data={'X':cdmprojection[:,0],
                              'Y':cdmprojection[:,1],
                              'Z':cdmprojection[:,2]})

fig.add_trace(
    go.Scatter3d(x=cdmprojection["X"],y=cdmprojection["Y"],z=cdmprojection["Z"]),
    row=2, col=2
)

#diff_of_distances (diffs)

# Set theme, margin, and annotation in layout ----------------------------------------------------
fig.update_layout(
    template="gridon", #plotly_dark
)
fig.show()

