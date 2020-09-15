// function fetchReviews(){
//     var reviewsButton = document.getElementById("reviews-button");

//     reviewsButton.addEventListener("click", event => {
//         event.preventDefault();
//         let get = { 
//             method: "GET",
//             headers: {
//                 "Content-Type": "application/json",
//                 "Accept": "application/json"
//             }
//         }

//         fetch(`/reviews`, get)
//         .then(resp => resp.json())
//         .then(json => {
//             console.log(json);
//             var renderReviews = document.getElementById("user-reviews-container");
//             var counter = 1;

//             json.data.forEach(element => {
//                 var article = document.createElement("article");
//                 article.className = "review-section";
//                 article.innerHTML = `
//                     <h3>${counter}.) <a href="/stores/${element.store_id}">${element.store}</a>: <a href="/stores/${element.store_id}#${element.title.replace(' ', '-')}">${element.title}</a></h3>
//                     <p>Created at: ${element.created_at}</p>
//                     <p>Created at: ${element.updated_at}</p>
//                     <p>${element.content}</p>
//                 `;
//                 renderReviews.appendChild(article);
//                 counter += 1;
//             });

//             if (json.reviews_exceeded_count == true){

//                 var path = window.location["pathname"];
//                 var userId = path.slice(path.length - 1, path.length);

//                 var navigation = document.createElement("p");
//                 var a = document.createElement("a");
//                 a.href = `/users/${userId}/reviews/1`;
//                 a.innerHTML = "See all Reviews?";

//                 navigation.appendChild(a);

//                 renderReviews.appendChild(navigation);
//                 counter += 1;
//             }
//             hideReviews(reviewsButton);
//         })
//     })

// }

// function hideReviews(reviewsButton){
//     let buttonContainer = document.getElementById("user-reviews-container");
//     let hideReviewsButton = document.createElement("button");

//     hideReviewsButton.innerHTML = "Hide Reviews";
//     reviewsButton.remove();
//     buttonContainer.appendChild(hideReviewsButton);

//     hideReviewsButton.addEventListener("click", event => {
//         event.preventDefault();

//         let nodeList = document.querySelectorAll(".review-section");

//         nodeList.forEach(element => {
//             element.style.display = "none"
//         })   
        
//         hideReviewsButton.remove();

//         let buttonContainer = document.getElementById("user-reviews-container");
//         let newButton = document.createElement("button");
//         newButton.id = "reviews-button"
//         newButton.innerHTML = "Reviews";

//         buttonContainer.appendChild(newButton);
//         adjustReviewsDisplay(newButton, nodeList);
//     })
// }

// function adjustReviewsDisplay(newButton, nodeList){

//     newButton.addEventListener("click", event => {
//         event.preventDefault();

//         nodeList.forEach(element => {
//             element.style.display = ""
//         })  
//         hideReviews(newButton)
//     })

// }

// fetchReviews();