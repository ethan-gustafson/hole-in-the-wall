var main = document.getElementById("search-main");
var form = document.getElementById("search-form");
var input = document.getElementById("search-input");
var state = document.getElementById("search-form-state-select");

form.addEventListener("submit", event => {
    event.preventDefault();
    var name = input.value;
    var stateValue = state.value;
    var value = {
                state: stateValue,
                name: name
            }

    let post = { 
    method: "POST",
    headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
    },
    body: JSON.stringify(value)
}

    fetch(`http://localhost:9393/stores/results`, post)
    .then(resp => resp.json())
    .then(json => {
        console.log(json)
        json.stores.forEach(element => {
            var section = document.createElement("section");
            section.setAttribute("class", "result-container")
            var result = document.createElement("h3");
            var link = document.createElement("a");
            link.href =`/stores/${element.id}`;
            var resultText = document.createTextNode(`${element.name}`);
            var stateText = document.createTextNode(`${element.state}: `);
            link.appendChild(resultText);
        
            link.appendChild(resultText);
            result.appendChild(stateText);
            result.appendChild(link);
            section.appendChild(result);
            main.appendChild(section);
        });
    })
})
