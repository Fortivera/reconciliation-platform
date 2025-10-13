import { Routes } from '@angular/router';
import { App } from './app'; // root app stays for '/'
export const routes: Routes = [
    { path: '', loadComponent: () => import('./pages/dashboard/dashboard').then(m => m.Dashboard) }
,
    {
        path: 'login',
        loadComponent: () => import('./pages/login/login').then(m => m.Login)
    }
];
