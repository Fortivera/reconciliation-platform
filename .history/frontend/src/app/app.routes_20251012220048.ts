import { Routes } from '@angular/router';
import { App } from './app'; // root app stays for '/'
export const routes: Routes = [
    { path: '', loadComponent: () => import('./pages/home/home').then(m => m.Home) }
,
    {
        path: 'login',
        loadComponent: () => import('./pages/login/login').then(m => m.Login)
    }
];
