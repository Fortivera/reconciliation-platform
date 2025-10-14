import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import {
    User,
    Transaction,
    ReconciliationMatch,
    MatchingRule,
    AuditLog,
    MatchSuggestion
} from './types';

@Injectable({
    providedIn: 'root',
})
export abstract class DataService {
    abstract getUsers(): Observable<User[]>;
    abstract getTransactions(): Observable<Transaction[]>;
    abstract getMatches(): Observable<ReconciliationMatch[]>;
    abstract getRules(): Observable<MatchingRule[]>;
    abstract getAuditLogs(): Observable<AuditLog[]>;
    abstract getMatchSuggestions(): Observable<MatchSuggestion[]>;
}
