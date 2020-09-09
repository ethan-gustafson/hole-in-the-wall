// Will be used to adjust html for review deletion

function fetchReviews(){
    var currentPath = window.location["pathname"]
    var path = currentPath.slice(currentPath.length - 1)
    var account = document.getElementById("account")
    account.addEventListener("click", event => {
            event.preventDefault();
            post = { 
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                }
            }
    
            fetch(`/reviews/${path}`, post)
            .then(resp => resp.json())
            .then(json => {
                console.log(json);
            })
        })
}

fetchReviews();
// function reviewsEdit(){

// }

// function reviewsDelete(){

// }