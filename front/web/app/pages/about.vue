<template></template>

<script setup lang="ts">
import { useRouter } from '#app'
import { RoutesEnum } from '~/config/constants'
useRouter().push(RoutesEnum.AREAS.toString());
</script>
