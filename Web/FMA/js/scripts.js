#!/usr/bin/env node

const penClick = document.querySelector(".clickSound");

function playSound(page) {
  penClick.play();
  setTimeout(
    function() {
      location.href = page;
    }, penClick.duration * 750);
}
