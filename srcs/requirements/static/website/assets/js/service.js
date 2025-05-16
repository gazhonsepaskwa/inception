function toggleSubDiv(button) {
    var parentDiv = button.parentElement;
    var childDiv = parentDiv.querySelector('.service__content');
    
    if (childDiv.style.display === "none") {
        childDiv.style.display = "block";
        button.textContent = "Know less"
    } else {
        childDiv.style.display = "none";
        button.textContent = "Know more"
    }
}
