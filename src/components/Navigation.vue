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
    <button
      @click="router.push('/')"
      :class="['nav-btn', { active: isHome }]"
    >
      Мероприятия
    </button>
    <button
      @click="router.push('/coworking')"
      :class="['nav-btn', { active: isCoworking }]"
    >
      Коворкинг
    </button>
  </nav>
</template>

<style scoped>
.main-nav {
  display: flex;
  gap: 1rem;
}

.nav-btn {
  background: rgba(255, 255, 255, 0.05);
  color: rgba(255, 255, 255, 0.7);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.nav-btn:hover {
  background: linear-gradient(135deg, #8b5cf6, #d946ef);
  color: white;
  transform: translateY(-1px);
}

.nav-btn.active {
  background: linear-gradient(135deg, #8b5cf6, #d946ef);
  color: white;
  border-color: transparent;
  box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
}

@media (max-width: 768px) {
  .nav-btn {
    flex: 1;
    text-align: center;
  }
}
</style>
