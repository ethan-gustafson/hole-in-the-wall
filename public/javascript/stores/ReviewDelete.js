function reviewDelete(){
    let buttonContainer = document.getElementById("button-container");
    let deleteButton = document.getElementById("delete-review");

    deleteButton.addEventListener("click", event => {
        event.preventDefault();
    })
}

reviewDelete();

{/* <form id="review-delete-form" action="/reviews/<%=review.id%>" method="post">
    <input type="hidden" name="_method" value="delete">
    <input type="submit" value="Delete Review?">
</form> */}