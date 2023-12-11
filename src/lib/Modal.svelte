<script>
  
  let dialog_created;
  
  onMount(async function () {
     dialog_created = document.getElementById('dialog_volume_created');
  });
  
</script>

<div class="container block ml-6 mr-6">
  <dialog id="dialog_volume_created">
    <div class="container content">
      <p>Volume created</p>
      <form method="dialog" align="center">
        <button align="center">OK</button>
      </form>
    </div>
  </dialog>
</div>
