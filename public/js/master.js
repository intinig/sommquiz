// Put all your page JS here

var quizJSON;

$(function () {

  var setQuestion = function(q) {
    quizJSON = {
      "info": {
        "name":    "Il Quiz del Sommelier",
        "main":    "<p>Pensi di essere pronto a diventare un Sommelier? Metti alla prova la tua conoscenza del mondo dei vini.</p>",
        "results": "<h5>Learn More</h5><p>Etiam scelerisque, nunc ac egestas consequat, odio nibh euismod nulla, eget auctor orci nibh vel nisi. Aliquam erat volutpat. Mauris vel neque sit amet nunc gravida congue sed sit amet purus.</p>",
        "level1":  "Sommelier",
        "level2":  "Aspirante Sommelier",
        "level3":  "Bevitore volenteroso",
        "level4":  "Bevitore di Tavernello",
        "level5":  "Astemio"
      },
      "questions": q.questions
    }
}

  $.getJSON('/question', function(data) {
    setQuestion(data);
    $('#slickQuiz').slickQuiz();
  })
});
