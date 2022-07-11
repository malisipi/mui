import malisipi.mui as m

import gx

mut app:=m.create(m.WindowConfig{ title:"Line Graph - MUI Example"})

app.line_graph(m.Widget{ id:"back", x:"25", y:"25", width:"100%x -50", height:"100%y -50",
    graph_title:"Comparison of GPA for Students by Years"
    graph_names:["A-Branch","B-Branch","C-Branch"],
    graph_label:["2019","2020", "2021", "2022"],
    graph_data: [
        [93,82,76,92]
        [71,95,63,66]
        [86,87,73,83]
    ],
    graph_color:[gx.Color{
        r: 20, g:20, b:255
    },
    gx.Color{
        r: 20, g:255, b:20
    },
    gx.Color{
        r: 255, g:20, b:20
    }
    ]
})

app.run()
