// function fetchFavorites(){
//     var favoritesButton = document.getElementById("favorites-button");

//     favoritesButton.addEventListener("click", event => {
//         event.preventDefault();
//         let get = { 
//             method: "GET",
//             headers: {
//                 "Content-Type": "application/json",
//                 "Accept": "application/json"
//             }
//         }

//         fetch(`/favorites`, get)
//         .then(resp => resp.json())
//         .then(json => {
//             console.log(json);
//             var renderFavorites = document.getElementById("user-favorites-container");
//             var counter = 1;

//             json.data.forEach(element => {

//                 var article = document.createElement("article");
//                 article.className = "favorite-section";

//                 article.innerHTML = `
//                         <h3>${counter}.) <a href="/stores/${element.store_id}">${element.store}</a></h3>
//                         <p><a href="/favorites/${element.id}/delete">Delete Favorite?</a></p>
//                     `;

//                 renderFavorites.appendChild(article);
//             });
            
//             if (json.favorites_exceeded_count == true){

//                 var path = window.location["pathname"];
//                 var userId = path.slice(path.length - 1, path.length);

//                 var navigation = document.createElement("p");
//                 var a = document.createElement("a");
//                 a.href = `/users/${userId}/favorites/1`;
//                 a.innerHTML = "See all favorites?";

//                 navigation.appendChild(a);

//                 renderFavorites.appendChild(navigation);
//                 counter += 1;
//             }
//             hideFavorites(favoritesButton);
//         })
//     })

// }

// function hideFavorites(favoritesButton){
//     let buttonContainer = document.getElementById("user-favorites-container");
//     let hideFavoritesButton = document.createElement("button");

//     hideFavoritesButton.innerHTML = "Hide Favorites";
//     favoritesButton.remove();
//     buttonContainer.appendChild(hideFavoritesButton);

//     hideFavoritesButton.addEventListener("click", event => {
//         event.preventDefault();

//         let nodeList = document.querySelectorAll(".favorite-section");

//         nodeList.forEach(element => {
//             element.style.display = "none"
//         })   
        
//         hideFavoritesButton.remove();

//         let newButton = document.createElement("button");
//         newButton.id = "favorites-button"
//         newButton.innerHTML = "Favorites";

//         buttonContainer.appendChild(newButton);
//         adjustFavoritesDisplay(newButton, nodeList);
//     })
// }

// function adjustFavoritesDisplay(newButton, nodeList){

//     newButton.addEventListener("click", event => {
//         event.preventDefault();

//         nodeList.forEach(element => {
//             element.style.display = ""
//         })  
//         hideFavorites(newButton)
//     })

// }

// fetchFavorites();