window.addEventListener('DOMContentLoaded', (event) => {
    getVisitCount();
});

const functionApi = 'https://tf-clouf-resume-challenge-tp.azurewebsites.net/api/GetVisitorCount'; // Change this to your Azure URL later!

const getVisitCount = () => {
    let count = 30; // Default/fallback
    fetch(functionApi)
    .then(response => {
        return response.json()
    })
    .then(response => {
        console.log("Website called function API.");
        count = response.count;
        document.getElementById('counter').innerText = count;
    }).catch(function(error) {
        console.log(error);
      });
    return count;
}