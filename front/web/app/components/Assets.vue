<template>
  <img :src="assetUrl" :alt="altText" />
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from 'vue';

import { getAssetUrl } from "~/domain/use-cases/assets";
import { AssetsRepository } from "~/infrastructure/repositories/AssetsRepository";

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
const assetUrl = ref<string>('');

const fetchAssetUrl = async () => {
  try {
    assetUrl.value = new getAssetUrl(new AssetsRepository()).execute(fileName.value);
  } catch (error) {
    console.error("Error fetching asset URL:", error);
    assetUrl.value = '';
  }
};

watch(fileName, () => {
  fetchAssetUrl();
});

onMounted(() => {
  fetchAssetUrl();
});
</script>

<style scoped lang="scss">
</style>
