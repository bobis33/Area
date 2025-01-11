import { defineNuxtPlugin } from "#app";
import { AssetsRepository } from "~/infrastructure/repositories/AssetsRepository";

export default defineNuxtPlugin((nuxtApp) => {
    nuxtApp.provide("assetsRepository", new AssetsRepository(useRuntimeConfig().public.baseUrlApi));
});
