import { Routes } from '@angular/router';
import { Login } from './pages/login/login';

export const routes: Routes = [
    { path: 'about', loadComponent: () => import('./pages/about/login').then(m => m.About) }
];
