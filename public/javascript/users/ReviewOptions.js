// Will be used to adjust html for review deletion

function fetchReviews(){
    var reviewsButton = document.getElementById("reviews-button");

    reviewsButton.addEventListener("click", event => {
            event.preventDefault();
            get = { 
                method: "GET",
                headers: {
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                }
            }
    
            fetch(`/reviews`, get)
            .then(resp => resp.json())
            .then(json => {
                console.log(json)
                reviewsButton.innerHTML = "Hide Reviews";
                var renderReviews = document.getElementById("user-reviews-list");
                var counter = 1;

                json.data.forEach(element => {
                    var article = document.createElement("article");
                    article.innerHTML = `
                        <h3>${counter}.) <a href="/stores/${element.store_id}">${element.store}</a>: <a href="/stores/${element.store_id}#${element.title.replace(' ', '-')}">${element.title}</a></h3>
                        <p>Created at: ${element.created_at}</p>
                        <p>Created at: ${element.updated_at}</p>
                        <p>${element.content}</p>
                    `
                    renderReviews.appendChild(article)
                    counter += 1
                });
            })
        })
}

fetchReviews();
// function reviewsEdit(){

// }

// function reviewsDelete(){

// }