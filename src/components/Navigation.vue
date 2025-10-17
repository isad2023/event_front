<script setup lang="ts">
import { useRouter, useRoute } from 'vue-router'
import { computed } from 'vue'

const router = useRouter()
const route = useRoute()

const isCoworking = computed(() => route.path === '/coworking')
const isHome = computed(() => route.path === '/')
</script>

<template>
  <nav class="main-nav">
    <h1
      @click="router.push('/')"
      :class="['nav-title', { active: isHome }]"
    >
      Мероприятия
    </h1>
    <h1
      @click="router.push('/coworking')"
      :class="['nav-title', { active: isCoworking }]"
    >
      Коворкинг
    </h1>
  </nav>
</template>

<style scoped>
.main-nav {
  display: flex;
  gap: 2rem;
}

.nav-title {
  margin: 0;
  font-size: 2.5rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s ease;
  color: rgba(255, 255, 255, 0.3);
  user-select: none;
}

.nav-title:hover {
  color: rgba(255, 255, 255, 0.6);
}

.nav-title.active {
  background: linear-gradient(135deg, #8b5cf6, #d946ef);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

@media (max-width: 768px) {
  .nav-title {
    font-size: 1.75rem;
  }

  .main-nav {
    gap: 1.5rem;
  }
}
</style>
