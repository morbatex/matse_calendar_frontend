<template>
  <div class="ui medium header">{{ listTitle }}</div>
  <div class="ui slider checkbox">
    <input
      type="checkbox"
      v-model="selectAll"
      @change="changeGlobalSelection"
    />
    <label>{{ "Select All" }}</label>
  </div>
  <div class="ui divider"></div>
  <div v-for="selectableCurse in selectableCurses" :key="selectableCurse.curse">
    <div class="ui slider checkbox">
      <input
        type="checkbox"
        v-model="selectableCurse.selected"
        @change="selectionChanged"
      />
      <label>{{ selectableCurse.curse }}</label>
    </div>
  </div>
  <br />
</template>

<script lang="ts">
import { defineComponent, PropType, reactive, ref, watchEffect } from "vue";

export default defineComponent({
  name: "CurseList",
  props: {
    listTitle: {
      type: String,
      required: true,
    },
    curses: {
      type: Array as PropType<Array<string>>,
      requiered: true,
    },
  },
  emits: ["selectionChanged"],
  setup(props, context) {
    const selectAll = ref(false);
    const selectableCurses = reactive(
      props?.curses
        ?.sort((left, right) =>
          left.toLowerCase() < right.toLowerCase() ? -1 : 1
        )
        .map((curse) => ({ curse, selected: false })) ?? []
    );
    function selectionChanged() {
      const selectedCurses = selectableCurses
        .filter((curse) => curse.selected)
        .map((curse) => curse.curse);
      context.emit("selectionChanged", selectedCurses);
    }
    function changeGlobalSelection() {
      selectableCurses.forEach((curse) => (curse.selected = selectAll.value));
      selectionChanged();
    }
    watchEffect(() => {
      selectableCurses.splice(0);
      const scs =
        props?.curses
          ?.sort((left, right) =>
            left.toLowerCase() < right.toLowerCase() ? -1 : 1
          )
          .map((curse) => ({ curse, selected: false })) ?? [];
      scs.forEach((scs) => selectableCurses.push(scs));
    });
    return {
      selectableCurses,
      selectAll,
      changeGlobalSelection,
      selectionChanged,
    };
  },
});
</script>
