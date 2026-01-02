window.addEventListener('DOMContentLoaded', (event) => {
    getVisitCount();
});

const functionApi = 'https://tp-resume-function-f6c0ccbxhsftcyc8.eastus-01.azurewebsites.net/api/GetVisitorCount'; // Change this to your Azure URL later!

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