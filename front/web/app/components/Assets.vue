<template>
    <img :src="assetUrl" :alt="altText" v-if="fileName" />
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useNuxtApp } from '#app';

const props = defineProps({
  fileName: {
    type: String,
    required: true,
  },
  altText: {
    type: String,
    default: 'image',
  },
});

const { fileName, altText } = toRefs(props);

const { $assetsRepository } = useNuxtApp();

const assetUrl = computed(() => {
  return $assetsRepository.getAssetUrl(fileName.value);
});
</script>

<style scoped lang="scss">
</style>
