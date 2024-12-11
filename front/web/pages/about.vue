<template></template>

<script setup lang="ts">
import { useRouter } from "#app";
import { RoutesEnum } from "~/constants";
useRouter().push(RoutesEnum.HOME.toString());
</script>
  