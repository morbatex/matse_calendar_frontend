<template>
  <form @submit.prevent="loadSemester">
    <select class="ui selection dropdown" v-model="state.winterSemester">
      <option value="true">Winter Semester</option>
      <option value="false">Summer Semester</option>
    </select>
    <div class="ui right labeled input">
      <input v-model="state.year" />
      <div class="ui label">Year</div>
    </div>
    <button class="ui labeled icon button">
      <i class="calendar icon"></i>
      Select Semester
    </button>
  </form>
  <div class="ui divider"></div>
  <form @submit.prevent="copyToClipboard">
    <div class="ui stackable grid">
      <div
        v-for="(curseCategorie, index) in state.curseCategories"
        :key="curseCategorie.name"
        class="column eight wide"
      >
        <CurseList
          :listTitle="curseCategorie.name"
          :curses="curseCategorie.curses"
          :isLoading="state.isLoading"
          @selectionChanged="updateSelectedCurses($event, index)"
        />
      </div>
    </div>
    <div
      class="ui disabled action input"
      v-bind:class="{ 'animate__animated animate__pulse': state.copied }"
      style="width: 100%"
    >
      <input type="text" v-model="state.urlString" />
      <button class="ui labeled icon button">
        <i
          v-bind:class="{
            'checkmark icon': state.copied,
            'clipboard icon': !state.copied,
          }"
        ></i>
        {{ state.copied ? "Copied" : "Copy Link" }}
      </button>
    </div>
  </form>
</template>

<script lang="ts">
import { defineComponent, proxyRefs, reactive, ref } from "vue";
import CurseList from "../components/CurseList.vue";
import "animate.css";

export default defineComponent({
  name: "Home",
  components: { CurseList },
  setup() {
    const date = new Date();
    const month = date.getMonth();
    let winterSemester = month < 2 || month >= 8;
    let year = month < 2 ? date.getFullYear() - 1 : date.getFullYear();
    const baseUrl = import.meta.env.VITE_API_URL;
    const calendarUrl = new URL(baseUrl + "/calendar");
    const eventNameUrl = new URL(baseUrl + "/eventCategories");
    let urlString = calendarUrl.toString();
    let copied = false;
    let isLoading = false;

    let curseCategories: any[] = [
      { name: "1. Lehrjahr", curses: [] },
      { name: "2. Lehrjahr", curses: [] },
      { name: "3. Lehrjahr", curses: [] },
      { name: "Wahlpflicht", curses: [] },
    ];
    const selectedCurses: string[][] = [];
    const state = reactive({
      curseCategories,
      year,
      winterSemester,
      urlString,
      copied,
      isLoading,
    });
    function generateLink() {
      eventNameUrl.searchParams.set(
        "winter_semester",
        state.winterSemester.toString()
      );
      eventNameUrl.searchParams.set("year", state.year.toString());
      const searchParams = calendarUrl.searchParams;
      searchParams.set("winter_semester", state.winterSemester.toString());
      searchParams.set("year", state.year.toString());
      searchParams.delete("curses");
      selectedCurses.forEach((selected) =>
        selected.forEach((curse) => searchParams.append("curses", curse))
      );
      state.urlString = calendarUrl.toString();
    }
    async function loadSemester() {
      selectedCurses.splice(0);
      generateLink();
      const resp = await fetch(eventNameUrl.toString());
      const respCurseCategories: any[] = await resp.json();
      state.curseCategories.splice(0, state.curseCategories.length);
      respCurseCategories.forEach((categorie) =>
        state.curseCategories.push(categorie)
      );
      state.isLoading = false;
    }
    function updateSelectedCurses(data: string[], index: number) {
      selectedCurses[index] = data;
      generateLink();
    }
    function copyToClipboard() {
      navigator.clipboard.writeText(state.urlString);
      if (!state.copied) {
        state.copied = true;
        setTimeout(() => (state.copied = false), 2500);
      }
    }
    loadSemester();
    return {
      copyToClipboard,
      loadSemester,
      updateSelectedCurses,
      state,
    };
  },
});
</script>
