#!/usr/bin/env node
const penClick = document.querySelector(".clickSound");
function playSound(page) {
  penClick.play();
  setTimeout(
    function() {
      location.href = page;
    }, penClick.duration * 750);
}

class Quiz {
  constructor() {
    //this.result = document.querySelector("#result");
    this.result = [];
    this.totalCount = 0;
    this.total = document.querySelector(".total");
    for(let i = 1; i <= 12; i++) {
      this.result.push(document.querySelector(`.result${i}`));
      this.result[i-1].innerHTML = "";
    }
    this.answers = [
    "Matavfall", "Pappersförpackningar", "Restavfall", "Wellpapp",
    "Tidningar", "Plastförpackningar", "Batterier", "Ljuskällor",
    "Småelektronik", "Metallförpackningar", "Färgade glasförpackningar",
    "Ofärgade glasförpackningar"
    ];

    for(let i = 1; i <= 12; i++) {
      var check = document.querySelector(`.q${i}`);
      if (check != null) {
        console.log("For loop: " + document.querySelector(`.q${i}`));
        this.correctQuiz(i, document.querySelector(`.q${i}`));
      } else {
        continue;
      }
    }
    this.showTotal();
  }

  correctQuiz(i, quiz) {
    const answer = quiz.querySelector("input[type=radio]:checked")
    console.log("Answer: " + answer);
    console.log("Answer value: " + answer.value);
    console.log("Variable i: " + i);
    console.log("Answers i: " + this.answers[i-1]);
    console.log("Result i: " + this.result[i-1]);
    if (answer != null) {
      if (this.answers[i-1].includes(answer.value)) {
        this.isCorrect(i, quiz)
      } else this.isWrong(i, quiz)
    }
  }

  isCorrect(i, quiz) {
    this.totalCount++;
    const correct = document.createElement("span");
    correct.textContent = "Rätt!";
    this.result[i-1].innerHTML = "";
    this.result[i-1].appendChild(correct);
  }
  
  isWrong(i, quiz) {
    const wrong = document.createElement("span");
    wrong.textContent = "Fel!";
    this.result[i-1].innerHTML = "";
    this.result[i-1].appendChild(wrong);
  }

  showTotal() {
    console.log("Count: " + this.totalCount);
    const count = document.createElement("span");
    this.total.innerHTML = "";
    count.textContent = this.totalCount + " av 12";
    this.total.appendChild(count);
  }
}

if (document.querySelector(".correct-quiz") != null) {
  const button = document.querySelector(".correct-quiz");
  button.addEventListener("click", event => {
  event.preventDefault();
  new Quiz();
  });
}

