// Put all your page JS here

var quizJSON;

$(function () {

  var setQuestion = function(q) {
    quizJSON = {
      "info": {
        "name":    "Il Quiz del Sommelier",
        "main":    "<p>Pensi di essere pronto a diventare un Sommelier? Metti alla prova la tua conoscenza del mondo dei vini.</p>",
        "results": "<h5>Quiz del Sommelier</h5><p>Il Quiz del Sommelier nasce per divertimento nella fucina di idee di <a href=\"http://www.mikamai.com\">MIKAMAI</a>, per aiutare tutti coloro che vogliono mettere alla prova la propria conoscenza del meraviglioso, e vasto, mondo del vino. Tutte le domande sono generate a caso, e tutti i vini che abbiamo bevuto durante lo sviluppo sono gentilmente offerti da <a href=\"http://www.vinodalproduttore.it\">Vinodalproduttore.it</a>, che seleziona per voi i migliori vini italiani. Segnalate imperfezioni o commenti a giovanni CHIOCCIOLA mikamai.com</p>",
        "level1":  "Sommelier",
        "level2":  "Aspirante Sommelier",
        "level3":  "Bevitore volenteroso",
        "level4":  "Bevitore di Tavernello",
        "level5":  "Astemio"
      },
      "questions": q.questions,
      "tryAgainText": "Riprova"
    }
}

  $.getJSON('/question', function(data) {
    setQuestion(data);
    $('#spinner').remove();
    $('#slickQuiz').slickQuiz();
  })
});
