<script setup lang="ts">
import { computed } from 'vue'

interface Event {
  id: string
  title: string
  short_description: string
  start_date: string
  location: string
  image_path: string
}

const props = defineProps<{
  event: Event
}>()

const formatDate = computed(() => {
  const date = new Date(props.event.start_date)
  return date.toLocaleDateString('ru-RU', {
    day: '2-digit',
    month: '2-digit',
    year: '2-digit'
  })
})

const formatTime = computed(() => {
  const date = new Date(props.event.start_date)
  return date.toLocaleTimeString('ru-RU', {
    hour: '2-digit',
    minute: '2-digit'
  })
})

const imageUrl = computed(() => {
  if (props.event.image_path && props.event.image_path.startsWith('http')) {
    return props.event.image_path
  }
  return props.event.image_path 
    ? `http://localhost:8000${props.event.image_path}`
    : 'https://images.pexels.com/photos/2747449/pexels-photo-2747449.jpeg?auto=compress&cs=tinysrgb&w=800'
})
</script>

<template>
  <div class="event-card">
    <div class="card-image">
      <img :src="imageUrl" :alt="event.title" />
      <div class="image-overlay"></div>
    </div>
    
    <div class="card-content">
      <h3 class="event-title">{{ event.title }}</h3>
      <p class="event-description">{{ event.short_description }}</p>
      
      <div class="event-details">
        <div class="detail-item">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
            <circle cx="12" cy="10" r="3"/>
          </svg>
          <span>{{ event.location }}</span>
        </div>
        
        <div class="detail-item">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10"/>
            <polyline points="12,6 12,12 8,14"/>
          </svg>
          <span>{{ formatDate }} {{ formatTime }}</span>
        </div>
      </div>
      
      <div class="card-action">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <line x1="5" y1="12" x2="19" y2="12"/>
          <polyline points="12,5 19,12 12,19"/>
        </svg>
      </div>
    </div>
  </div>
</template>

<style scoped>
.event-card {
  background: rgba(30, 30, 30, 0.8);
  backdrop-filter: blur(10px);
  border-radius: 16px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
  position: relative;
}

.event-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.3);
  border-color: rgba(255, 107, 53, 0.3);
}

.card-image {
  position: relative;
  height: 200px;
  overflow: hidden;
}

.card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.event-card:hover .card-image img {
  transform: scale(1.05);
}

.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(180deg, transparent 0%, rgba(0, 0, 0, 0.7) 100%);
}

.card-content {
  padding: 1.5rem;
  position: relative;
}

.event-title {
  margin: 0 0 0.75rem 0;
  font-size: 1.25rem;
  font-weight: 700;
  color: white;
  line-height: 1.3;
}

.event-description {
  margin: 0 0 1.5rem 0;
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.95rem;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.event-details {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  margin-bottom: 1rem;
}

.detail-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #ff6b35;
  font-size: 0.9rem;
  font-weight: 500;
}

.detail-item svg {
  flex-shrink: 0;
}

.detail-item span {
  color: rgba(255, 255, 255, 0.9);
}

.card-action {
  position: absolute;
  bottom: 1.5rem;
  right: 1.5rem;
  color: #ff6b35;
  transition: transform 0.3s ease;
}

.event-card:hover .card-action {
  transform: translateX(4px);
}

@media (max-width: 768px) {
  .card-content {
    padding: 1.25rem;
  }

  .event-title {
    font-size: 1.1rem;
  }

  .event-description {
    font-size: 0.9rem;
  }
}
</style>