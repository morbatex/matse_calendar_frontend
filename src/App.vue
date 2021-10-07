<template>
  <div class="ui fixed inverted menu">
    <div class="ui left aligned container">
      <div id="header" class="ui inverted large header">MATSE CALENDAR</div>
    </div>
  </div>
  <div id="main" class="ui left aligned container"><Home /></div>
  <div id="footer" class="ui inverted vertical footer segment">
    <div class="ui left aligned container">
      <div class="ui inverted medium header">
        Visit the Repository on
        <a
          class="ui"
          href="https://github.com/morbatex/matse_calendar_frontend"
          target="blank"
          >Github</a
        >
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Home from "./views/Home.vue";
import { defineComponent } from "vue";

export default defineComponent({
  components: { Home },
});
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
  text-align: start;
}
html {
  overflow: hidden;
}
#main {
  margin-bottom: 60px;
}
#header {
  margin-top: 8px;
}
#footer {
  position: fixed;
  width: 100%;
  top: calc(100vh - 48px);
  z-index: 10;
}
</style>
