function show_list(){
    handler("get_list").then((lst)=>{
        let html = "";
        for(let i=0;i<lst.length;i++){
            html+="<li class=\"article-name\" onclick=\"show_article("+lst[i].id+");\">"+lst[i].title+"</li>";
        }
        document.body.innerHTML="<h1>Articles</h1><ul>"+html+"</ul>";
    })
}

function show_article(id){
    handler('get_article',String(id)).then((art)=>{
        document.body.innerHTML="<button onclick=\"show_list();\">Go Back</button><h1>"+art.title+"#"+art.id+"</h1><p>"+art.text+"</p>"
    })
}

show_list();
