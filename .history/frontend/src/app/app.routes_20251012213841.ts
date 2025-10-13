import { Routes } from '@angular/router';
import { Login } from './pages/login/login';

export const routes: Routes = [
    { path: 'about', loadComponent: () => import('./pages/loginlogin').then(m => m.About) }
];
