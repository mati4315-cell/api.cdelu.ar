// 🔧 Tipos TypeScript para el Sistema de Feed Unificado
// Archivo: src/types/feed.ts

/**
 * Tipo de contenido en el feed
 */
export type FeedType = 1 | 2; // 1=noticias, 2=comunidad

/**
 * Pestañas disponibles en el feed
 */
export type FeedTab = 'todo' | 'noticias' | 'comunidad';

/**
 * Campos disponibles para ordenación
 */
export type FeedSortField = 'titulo' | 'published_at' | 'created_at' | 'likes_count' | 'comments_count';

/**
 * Dirección de ordenación
 */
export type FeedSortOrder = 'asc' | 'desc';

/**
 * Parámetros para consultas del feed
 */
export interface FeedParams {
  page?: number;
  limit?: number;
  type?: FeedType;
  sort?: FeedSortField;
  order?: FeedSortOrder;
}

/**
 * Item individual del feed (contenido unificado)
 */
export interface FeedItem {
  /** ID en la tabla content_feed */
  id: number;
  
  /** Título del contenido */
  titulo: string;
  
  /** Descripción/contenido principal */
  descripcion: string;
  

  /** URL de imagen asociada */
  image_url?: string;
  
  /** Tipo de contenido: 1=noticia, 2=comunidad */
  type: FeedType;
  
  /** ID original en la tabla source (news/com) */
  original_id: number;
  
  /** ID del usuario creador */
  user_id?: number;
  
  /** Nombre del usuario creador */
  user_name?: string;
  
  /** Fecha de publicación */
  published_at?: string;
  
  /** Fecha de creación */
  created_at: string;
  
  /** Fecha de última actualización */
  updated_at: string;
  
  // Campos específicos de noticias (type=1)
  /** URL de la fuente original (solo noticias) */
  original_url?: string;
  
  /** Si es contenido oficial (solo noticias) */
  is_oficial?: boolean;
  
  // Campos específicos de comunidad (type=2)
  /** URL de video (solo comunidad) */
  video_url?: string;
  
  // Estadísticas
  /** Número de likes */
  likes_count: number;
  
  /** Número de comentarios */
  comments_count: number;
}

/**
 * Información de paginación
 */
export interface FeedPagination {
  /** Total de elementos */
  total: number;
  
  /** Página actual */
  page: number;
  
  /** Elementos por página */
  limit: number;
  
  /** Total de páginas */
  totalPages: number;
}

/**
 * Respuesta completa del feed
 */
export interface FeedResponse {
  /** Datos del feed */
  data: FeedItem[];
  
  /** Información de paginación */
  pagination: FeedPagination;
}

/**
 * Estadísticas por tipo de contenido
 */
export interface FeedTypeStats {
  /** Número de elementos */
  count: number;
  
  /** Total de likes */
  likes: number;
  
  /** Total de comentarios */
  comments: number;
}

/**
 * Estadísticas completas del feed
 */
export interface FeedStats {
  /** Total de elementos en el feed */
  total: number;
  
  /** Estadísticas por tipo */
  by_type: {
    /** Estadísticas de noticias */
    news: FeedTypeStats;
    
    /** Estadísticas de comunidad */
    community: FeedTypeStats;
  };
}

/**
 * Estado de paginación por pestaña
 */
export interface TabPagination {
  /** Página actual */
  page: number;
  
  /** Si hay más contenido disponible */
  hasMore: boolean;
  
  /** Total de elementos */
  total: number;
}

/**
 * Estado completo del store del feed
 */
export interface FeedState {
  // Contenido por pestaña
  /** Contenido de la pestaña "Todo" */
  allContent: FeedItem[];
  
  /** Contenido de la pestaña "Noticias" */
  newsContent: FeedItem[];
  
  /** Contenido de la pestaña "Comunidad" */
  communityContent: FeedItem[];
  
  // Estado de UI
  /** Pestaña actualmente activa */
  currentTab: FeedTab;
  
  /** Si está cargando contenido inicial */
  isLoading: boolean;
  
  /** Si está cargando más contenido (infinite scroll) */
  isInfiniteLoading: boolean;
  
  // Paginación por pestaña
  /** Estado de paginación de cada pestaña */
  pagination: {
    todo: TabPagination;
    noticias: TabPagination;
    comunidad: TabPagination;
  };
  
  // Estadísticas
  /** Estadísticas del feed */
  stats: FeedStats | null;
  
  // Manejo de errores
  /** Mensaje de error actual */
  error: string | null;
}

/**
 * Props para el componente principal del feed
 */
export interface FeedMainProps {
  /** Configuración inicial (opcional) */
  initialTab?: FeedTab;
  
  /** Elementos por página */
  pageSize?: number;
  
  /** Si mostrar estadísticas */
  showStats?: boolean;
  
  /** Si habilitar infinite scroll */
  enableInfiniteScroll?: boolean;
}

/**
 * Props para el componente de pestañas
 */
export interface FeedTabsProps {
  /** Pestaña actualmente activa */
  currentTab: FeedTab;
  
  /** Estadísticas para mostrar contadores */
  stats?: FeedStats | null;
  
  /** Si deshabilitar alguna pestaña */
  disabledTabs?: FeedTab[];
}

/**
 * Eventos del componente de pestañas
 */
export interface FeedTabsEmits {
  /** Evento cuando cambia de pestaña */
  'tab-change': [tab: FeedTab];
}

/**
 * Props para el componente de item del feed
 */
export interface FeedItemProps {
  /** Item a mostrar */
  item: FeedItem;
  
  /** Si mostrar acciones (like, compartir, etc.) */
  showActions?: boolean;
  
  /** Si truncar la descripción */
  truncateDescription?: boolean;
  
  /** Longitud máxima de descripción */
  maxDescriptionLength?: number;
}

/**
 * Eventos del componente de item del feed
 */
export interface FeedItemEmits {
  /** Evento cuando se hace click en el item */
  'item-click': [item: FeedItem];
  
  /** Evento cuando se da like */
  'like': [item: FeedItem];
  
  /** Evento cuando se comparte */
  'share': [item: FeedItem];
  
  /** Evento cuando se hace click en comentarios */
  'comments': [item: FeedItem];
}

/**
 * Props para el componente de lista del feed
 */
export interface FeedListProps {
  /** Items a mostrar */
  items: FeedItem[];
  
  /** Si está cargando más contenido */
  isLoading?: boolean;
  
  /** Texto cuando no hay items */
  emptyText?: string;
  
  /** Si habilitar infinite scroll */
  enableInfiniteScroll?: boolean;
}

/**
 * Eventos del componente de lista del feed
 */
export interface FeedListEmits {
  /** Evento para cargar más contenido */
  'load-more': [];
  
  /** Evento cuando se selecciona un item */
  'item-select': [item: FeedItem];
}

/**
 * Props para el componente de header del feed
 */
export interface FeedHeaderProps {
  /** Estadísticas a mostrar */
  stats: FeedStats;
  
  /** Si mostrar botón de refresh */
  showRefresh?: boolean;
  
  /** Título personalizado */
  title?: string;
}

/**
 * Eventos del componente de header del feed
 */
export interface FeedHeaderEmits {
  /** Evento cuando se hace click en refresh */
  'refresh': [];
}

/**
 * Opciones de configuración del servicio
 */
export interface FeedServiceConfig {
  /** URL base de la API */
  baseURL: string;
  
  /** Timeout para requests */
  timeout?: number;
  
  /** Headers adicionales */
  headers?: Record<string, string>;
  
  /** Si incluir credentials */
  withCredentials?: boolean;
}

/**
 * Respuesta de error de la API
 */
export interface FeedApiError {
  /** Mensaje de error */
  message: string;
  
  /** Código de error */
  code?: string;
  
  /** Detalles adicionales */
  details?: any;
  
  /** Timestamp del error */
  timestamp?: string;
}

/**
 * Funciones del servicio de feed
 */
export interface FeedService {
  /** Obtener feed completo */
  getFeed(params?: FeedParams): Promise<FeedResponse>;
  
  /** Obtener solo noticias */
  getNews(params?: FeedParams): Promise<FeedResponse>;
  
  /** Obtener solo contenido de comunidad */
  getCommunity(params?: FeedParams): Promise<FeedResponse>;
  
  /** Obtener estadísticas */
  getFeedStats(): Promise<FeedStats>;
  
  /** Obtener item específico */
  getFeedItem(type: FeedType, id: number): Promise<FeedItem>;
}

/*
 * NOTA: Los siguientes tipos requieren Vue 3 y deben estar en el proyecto frontend
 * Descomenta esta sección cuando copies estos tipos a tu proyecto Vue:
 *
 * import type { Ref } from 'vue';
 * 
 * export interface UseFeedReturn {
 *   // Estado reactivo
 *   currentContent: Readonly<Ref<FeedItem[]>>;
 *   currentTab: Ref<FeedTab>;
 *   isLoading: Readonly<Ref<boolean>>;
 *   isInfiniteLoading: Readonly<Ref<boolean>>;
 *   stats: Readonly<Ref<FeedStats | null>>;
 *   error: Readonly<Ref<string | null>>;
 *   pagination: Readonly<Ref<TabPagination>>;
 *   
 *   // Acciones
 *   loadFeed: (tab?: FeedTab, refresh?: boolean) => Promise<void>;
 *   loadMore: () => Promise<void>;
 *   switchTab: (tab: FeedTab) => Promise<void>;
 *   refresh: () => Promise<void>;
 *   loadStats: () => Promise<void>;
 * }
 */ 